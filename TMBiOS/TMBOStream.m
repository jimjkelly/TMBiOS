//
//  TMBOStream.m
//  TMBiOS
//
//  Created by Jim Kelly on 5/22/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//
//  The stream object is designed to get a list of uploads
//  of various types, and then download them to a cache
//  so as to make them available for quick viewing.  As the
//  user moves through the stream, the window of items cached
//  should move.  Items outside the window should be freed,
//  and items newly within the window should be added.

#import "TMBOStream.h"
#import "TMBOPoast.h"

@interface TMBOStream()
// points to current location in the stream
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSMutableDictionary *stream;
@end

@implementation TMBOStream

@synthesize index = _index;
@synthesize stream = _stream;

- (NSNumber *)index {
    if (_index == nil) _index = [[NSNumber alloc] initWithInt:1];
    return _index;
}

-(id)init {
    if (self = [super init])
    {
        // Load from prefs
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *dataRepresentingSavedDict = [prefs objectForKey:@"stream"];
        if (dataRepresentingSavedDict != nil) {
            NSDictionary *oldSavedDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedDict];
            if (oldSavedDict != nil)
                self.stream = [[NSMutableDictionary alloc] initWithDictionary:oldSavedDict];
            else
                self.stream = [[NSMutableDictionary alloc] init];
        }
        
        
    }
    return self;
}

-(void)saveStream {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject: self.stream] forKey:@"stream"];
    [prefs synchronize];
}

-(void)dealloc {
    [self saveStream];
}

- (UIImage *)getImageAt:(NSNumber *)index {
    return [[self.stream objectForKey:[index stringValue]] getImage];
}

- (UIImage *)getPreviousImage {
    self.index = [NSNumber numberWithInt:[self.index intValue] - 1];
    return [self getImageAt:self.index];
}

- (UIImage *)getNextImage {
    self.index = [NSNumber numberWithInt:[self.index intValue] + 1];
    return [self getImageAt:self.index];
}

- (UIImage *)getCurrentImage {
    return [self getImageAt:self.index];
}

- (void)getUploadsDidFinish:(NSArray *)uploads {
    if ([uploads count] != 0) {
        for (id object in uploads) {
            if ([self.stream objectForKey:[object objectForKey:@"id"]] == nil) {
                NSLog(@"Creating poast object from %@", object);
                [self.stream setObject:[[TMBOPoast alloc] initWithPoastDict:object] forKey:[object objectForKey:@"id"]];
            } else {
                NSLog(@"id %@ already exists", [object objectForKey:@"id"]);
            }
        }
        
        // Notify the ImageViewController that the stream has been loaded
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"TMBOStreamLoaded" object:self];
        
        [self saveStream];
    }
}

@end
