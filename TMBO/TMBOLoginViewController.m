//
//  TMBOViewController.m
//  TMBO
//
//  Created by Jim Kelly on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TMBOLoginViewController.h"
#import "TMBOImageViewController.h"
#import "TMBO-API.h"

@interface TMBOLoginViewController()
@property (nonatomic, strong) TMBO_API *tmbo;
@end


@implementation TMBOLoginViewController

@synthesize username = _username;
@synthesize password = _password;
@synthesize activity = _activity;
@synthesize tmbo = _tmbo;

- (TMBO_API *)tmbo {
    if (!_tmbo) _tmbo = [[TMBO_API alloc] init];
    return _tmbo;
}


- (IBAction)loginPressed:(UIButton *)sender {
    // Here we initiate a login sequence in the tmbo model.
    // The result will return to loginConnectionDidFinish
    [self.tmbo loginWithUsername:[self.username text]
                     andPassowrd:[self.password text]
                    withDelegate:self];
    
    self.activity.hidden = NO;
    [self.activity startAnimating];
}

- (void)loginSucceededOnwardTittiesAndKitties {
    [self performSegueWithIdentifier:@"LoginToImages" sender:self];
}

- (void)loginConnectionDidFinish:(NSNumber *)loginResult {
    [self.activity stopAnimating];
    self.activity.hidden = YES;
    if (loginResult) {
        // move on to titties and kitties
        [self loginSucceededOnwardTittiesAndKitties];
        NSLog(@"Titties and kitties!");
    } else {
        // We couldn't log in
        NSLog(@"Error logging in");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.username = nil;
    self.password = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tmbo.authToken) {
        NSLog(@"No need to auth, we have a saved token");
        [self loginSucceededOnwardTittiesAndKitties];
    }
    
    [self.view setBackgroundColor: [[self class] colorFromHexString:@"333366"]];
    
    self.activity.hidden = YES;
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
        
        if ([view isKindOfClass:[UITextView class]]) {
            [view resignFirstResponder];
        }
    }
}

@end
