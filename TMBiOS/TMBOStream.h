//
//  TMBOStream.h
//  TMBiOS
//
//  Created by Jim Kelly on 5/22/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMBOStream : NSObject
- (NSString *)getNextImageLink;
- (NSString *)getPreviousImageLink;
- (NSString *)getCurrentImageLink;
@end
