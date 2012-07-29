//
//  TMBOImageViewController.h
//  TMBO
//
//  Created by Jim Kelly on 2/9/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMBOBaseViewController.h"
#import "TMBO-API.h"

@interface TMBOImageViewController : TMBOBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *tIG;
@property (weak, nonatomic) IBOutlet UIButton *tIB;
//@property (nonatomic, retain) TMBOStream *stream;
@property (nonatomic, assign) id delegate;
@end

