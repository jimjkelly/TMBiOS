//
//  TMBOBaseViewController.h
//  TMBO
//
//  Created by Jim Kelly on 2/8/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMBO-API.h"

@interface TMBOBaseViewController : UIViewController
@property (nonatomic, strong) TMBO_API *tmbo;
+ (UIColor *) colorFromHexString: (NSString *) hex;
@end
