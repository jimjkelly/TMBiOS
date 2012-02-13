//
//  TMBOImageViewController.h
//  TMBO
//
//  Created by Jim Kelly on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMBOBaseViewController.h"

@interface TMBOImageViewController : TMBOBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, assign) id delegate;
@end
