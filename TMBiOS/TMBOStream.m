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
@property (nonatomic, strong) NSOperationQueue *cachingQueue;
@property (nonatomic, strong) NSOperationQueue *commentQueue;
@end

@implementation TMBOStream

@synthesize index = _index;
@synthesize stream = _stream;
@synthesize cachingQueue = _cachingQueue;
@synthesize commentQueue = _commentQueue;

- (NSNumber *)index {
    if (_index == nil) _index = [[NSNumber alloc] initWithInt:1];
    return _index;
}

- (NSMutableDictionary *)stream {
    if (_stream == nil) _stream = [[NSMutableDictionary alloc] init];
    return _stream;
}

- (NSOperationQueue *)cachingQueue {
    if (_cachingQueue == nil) _cachingQueue = [[NSOperationQueue alloc] init];
    return _cachingQueue;
}

- (NSOperationQueue *)commentQueue {
    if (_commentQueue == nil) _commentQueue = [[NSOperationQueue alloc] init];
    return _commentQueue;
}

-(id)init {
    if (self = [super init])
    {
        // Uncomment below to clear the stream
        [self clearStream];
        
        // Load from prefs
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *dataRepresentingSavedDict = [prefs objectForKey:@"stream"];
        if (dataRepresentingSavedDict != nil) {
            NSDictionary *oldSavedDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedDict];
            if (oldSavedDict != nil)
                self.stream = [[NSMutableDictionary alloc] initWithDictionary:oldSavedDict];
        } 
    }
    return self;
}

-(void)dealloc {
    [self saveStream];
}

-(void)saveStream {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject: self.stream] forKey:@"stream"];
    [prefs synchronize];
}

// NOTE: this clears the local stream, may mostly be useful for development work
-(void)clearStream {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"stream"];
    [prefs synchronize];
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

- (NSNumber *)getCurrentID {
    return [[self.stream objectForKey:[self.index stringValue]] getID];
}

- (void)getUploadsDidFinish:(NSArray *)uploads {
    if ([uploads count] != 0) {
        for (id object in uploads) {
            if ([self.stream objectForKey:[object objectForKey:@"id"]] == nil) {
                NSLog(@"Creating poast object from %@", object);
                TMBOPoast *newPoast = [[TMBOPoast alloc] initWithPoastDict:object];
                
                [self.cachingQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:newPoast
                                                                                     selector:@selector(cacheImage) object:nil]];
                
                [self.commentQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:newPoast
                                                                                     selector:@selector(cacheComments) object:nil]];
                
                [self.stream setObject:newPoast forKey:[object objectForKey:@"id"]];
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
