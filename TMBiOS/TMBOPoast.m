//
//  TMBOPoast.m
//  TMBiOS
//
//  Created by James Kelly on 7/28/12.
//
//

/*

The following shows an example of the data dictionary:
 
 {
 comments = 0;
 filename = "338703_one fish two fish, red fish blue fish.jpeg";
 filtered = 0;
 height = 800;
 id = 5;
 "last_active" = "2012-07-30 03:26:00";
 "link_file" = "/offensive/uploads/2012/07/30/image/5_338703_one%20fish%20two%20fish%2C%20red%20fish%20blue%20fish.jpeg";
 "link_thumb" = "/offensive/uploads/2012/07/30/image/thumbs/th5.jpeg";
 nsfw = 0;
 subscribed = 0;
 "thumb_height" = 100;
 "thumb_width" = 133;
 timestamp = "2012-07-30 03:26:00";
 tmbo = 0;
 type = image;
 userid = 2;
 username = asdf;
 "vote_bad" = 0;
 "vote_good" = 0;
 "vote_repost" = 0;
 "vote_tmbo" = 0;
 width = 1000;
 }

 
 */
#import "TMBOPoast.h"
#import "TMBO-API.h"

@interface TMBOPoast()
@property (nonatomic, strong) TMBO_API *tmbo;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *local_path;
@property (nonatomic, assign) BOOL seen;
@end

@implementation TMBOPoast

@synthesize data = _data;
@synthesize seen = _seen;
@synthesize local_path = _local_path;

- (TMBO_API *)tmbo {
    if (!_tmbo) _tmbo = [[TMBO_API alloc] init];
    return _tmbo;
}

- (NSString *)local_path {
    // we create a local path based on the link_file path on the tmbo server, cause it's unique! (we hope!)
    // NOTE: we're making an assumption here that link_file is available.  It should be, but let's raise
    // an obvious exception if not:
    if (![self.data objectForKey:@"link_file"]) {
        [NSException raise:@"There does not seem to be a link_file value set!" format:@"%@ does not have link_file value set", self];
    }
    if (!_local_path) _local_path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: [self.data objectForKey:@"link_file"]];
    return _local_path;
}

-(id)initWithPoastDict:(NSDictionary *)poastDict {
    if (self = [super init])
    {
        self.data = poastDict;
        self.seen = NO;
    }
    return self;
}

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[TMBOPoast alloc] init];
    if (self != nil)
	{
		self.data = [coder decodeObjectForKey:@"data"];
		self.seen = [coder decodeBoolForKey:@"seen"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.data forKey:@"data"];
    [coder encodeBool:self.seen forKey:@"seen"];
}

// This is currently the gateway to a Poast from the outside world.
// Eventually you won't be getting a link, but the object data to
// display, as the Poast will be handling caching the data itself.
-(UIImage *)getImage {
    // Since as we add images we currently cache images, we suspect it'll come along
    // at some point, so we wait.
    while(![[NSFileManager defaultManager] fileExistsAtPath: self.local_path]) {
        sleep(1);
    }
    
    self.seen = YES;
    
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:self.local_path];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    return image;
}

-(BOOL)hasBeenSeen {
    NSLog(@"Checking whether %@ has been seen: %@", [self.data objectForKey:@"filename"], self.seen ? @"YES" : @"NO");
    return self.seen;
}

// cacheImage will cacheImage if it does not exist.  It does nothing if it does.
-(void)cacheImage {
    if(![[NSFileManager defaultManager] fileExistsAtPath: self.local_path]) {
        NSLog(@"caching %@", [self.local_path lastPathComponent]);
        NSError *error = nil;
        
        // Create the intermediary directories if they don't exist
        if (![[NSFileManager defaultManager] createDirectoryAtPath:[self.local_path stringByDeletingLastPathComponent]
									   withIntermediateDirectories:YES
														attributes:nil
															 error:&error])
		{
			NSLog(@"%s: Create directory error for path %@: %@", __func__, self.local_path, error);
		}
        
        // the file doesn't exist locally, let's get it
        NSData *imageData = [self.tmbo getNSDataFromFilePath:[self.data objectForKey:@"link_file"]];

        // Now save the data
        BOOL result = [imageData writeToFile:self.local_path options:NSDataWritingAtomic error:&error];
        if (!result) {
            NSLog(@"%s: Failed to write atomically to path %@: %@", __func__, self.local_path, error);
        }
        
    }
}

@end