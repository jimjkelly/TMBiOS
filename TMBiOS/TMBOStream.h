//
//  TMBOStream.h
//  TMBiOS
//
//  Created by Jim Kelly on 5/22/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBOStream : NSObject
- (UIImage *)getNextImage;
- (UIImage *)getPreviousImage;
- (UIImage *)getCurrentImage;
- (NSNumber *)getCurrentID;
- (NSNumber *)getNumOfComments;
@end
