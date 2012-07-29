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
@property (nonatomic, strong) NSArray *stream;
@end

@implementation TMBOStream

@synthesize index = _index;
@synthesize stream = _stream;

- (NSString *)getLinkToImageAt:(NSNumber *)index {
    return [[self.stream objectAtIndex:[self.index integerValue]] objectForKey:@"link_file"];
}

- (NSString *)getPreviousImageLink {
    self.index = [NSNumber numberWithInt:[self.index intValue] - 1];
    return [self getLinkToImageAt:self.index];
}

- (NSString *)getNextImageLink {
    self.index = [NSNumber numberWithInt:[self.index intValue] + 1];
    return [self getLinkToImageAt:self.index];
}

- (NSString *)getCurrentImageLink {
    return [self getLinkToImageAt:self.index];
}

- (void)getUploadsDidFinish:(NSArray *)uploads {
    if ([uploads count] != 0) {
        NSLog(@"Setting image stream");
        NSLog(@"Returned from server: %@", uploads);
        self.stream = uploads;
        self.index = 0;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"TMBOStreamLoaded" object:self];
    }
}

@end
