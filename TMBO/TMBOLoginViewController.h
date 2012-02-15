//
//  TMBOViewController.h
//  TMBO
//
//  Created by Jim Kelly on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMBOBaseViewController.h"

@interface TMBOLoginViewController : TMBOBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *loginError;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

- (void)loginConnectionDidFinish:(NSNumber *)loginResult;

@end
