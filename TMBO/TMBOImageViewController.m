//
//  TMBOImageViewController.m
//  TMBO
//
//  Created by Jim Kelly on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TMBOImageViewController.h"
#import "TMBO-API.h"

@interface TMBOImageViewController()
@property (nonatomic, strong) TMBO_API *tmbo;
@property (nonatomic, strong) NSArray *imageStream;
@property (nonatomic, strong) NSNumber *currentIndex;
@end

@implementation TMBOImageViewController
@synthesize imageStream = _imageStream;

@synthesize image = _image;
@synthesize currentIndex = _currentIndex;
@synthesize delegate = _delegate;
@synthesize tmbo = _tmbo;

- (NSNumber *)currentIndex {
    if (!_currentIndex) _currentIndex = [[NSNumber alloc] initWithInt:0];
    return _currentIndex;
}

- (NSArray *)imageStream {
    if (!_imageStream) _imageStream = [[NSArray alloc] init];
    return _imageStream;
}

- (IBAction)logoutPressed:(UIButton *)sender {
    [self.tmbo logout];
    NSLog(@"Logout pressed by user");
    [self performSegueWithIdentifier:@"ImagesToLogin" sender:self];
}

- (IBAction)toggleNSFW:(UIButton *)sender {
    NSLog(@"NSFW filter was set to %@", self.tmbo.shouldShowNSFW ? @"YES" : @"NO");
    self.tmbo.showNSFW = !self.tmbo.shouldShowNSFW;
    NSLog(@"NSFW filter is now set to %@", self.tmbo.shouldShowNSFW ? @"YES" : @"NO");
    // Refresh the list.
    [self.tmbo getUploadswithDelegate:self ofType:@"image"];
}

- (IBAction)toggleTMBO:(UIButton *)sender {
    NSLog(@"TMBO filter was set to %@", self.tmbo.shouldShowTMBO ? @"YES" : @"NO");
    self.tmbo.showTMBO = !self.tmbo.shouldShowTMBO;
    NSLog(@"TMBO filter is now set to %@", self.tmbo.shouldShowTMBO ? @"YES" : @"NO");
    // Refresh the list.
    [self.tmbo getUploadswithDelegate:self ofType:@"image"];
}

- (IBAction)voteOnImage:(UIButton *)sender {
    NSString *vote = sender.currentTitle;
    NSLog(@"User votes %@ on photo %d", vote, [self.currentIndex intValue]);
}

- (void)setCurrentIndex:(NSNumber *)currentIndex {
    if ([currentIndex intValue] <= 0) {
        NSLog(@"Setting index to 0, as attempt was made to set to %@", currentIndex);
        _currentIndex = 0;
    } else if ([currentIndex intValue] >= [self.imageStream count]) {
        NSLog(@"Setting index to the imageStream count, as we attempted to set to %@", currentIndex);
        _currentIndex = [[NSNumber alloc] initWithInt:[self.imageStream count]];
    } else {
        NSLog(@"Setting index to %@", currentIndex);
        _currentIndex = currentIndex;
    }
}

- (TMBO_API *)tmbo {
    if (!_tmbo) _tmbo = [[TMBO_API alloc] init];
    return _tmbo;
}

- (void)loginFailed {
    // do stuffs for a login failure.  What's a login failure doing here?
    // if our authToken is invalidated, this could happpen.  Kick us
    // back to the login screen.  In the future we may want to consider
    // providing a message about why this happened.
    NSLog(@"Login no longer accepted, kicking back to login screen");
    [self performSegueWithIdentifier:@"ImagesToLogin" sender:self];
}

- (void)viewImageAtIndex:(NSNumber *)index {
    self.currentIndex = index;
    NSLog(@"Viewing image at index %@", self.currentIndex);
    NSString *link_file = [[self.imageStream objectAtIndex:[self.currentIndex integerValue]] objectForKey:@"link_file"];
    
    NSLog(@"Downloading contents of %@", link_file);
    [self.image setImage:[self.tmbo getUIImageFromFilePath:link_file]];
    NSLog(@"done.");
}

- (void)getUploadsDidFinish:(NSArray *)uploads {
    if ([uploads count] != 0) {
        NSLog(@"Setting image stream");
        self.imageStream = uploads;
        self.currentIndex = 0;
        [self viewImageAtIndex:self.currentIndex];
    }
}




- (void)oneFingerSwipeUp:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle swipe left
    [self viewImageAtIndex:[[NSNumber alloc] initWithInt:[self.currentIndex integerValue] + 1]];
}


- (void)oneFingerSwipeDown:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle swipe left
    [self viewImageAtIndex:[[NSNumber alloc] initWithInt:[self.currentIndex integerValue] - 1]];
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
    
    UISwipeGestureRecognizer *oneFingerSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeUp:)];
    [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:oneFingerSwipeUp];

    UISwipeGestureRecognizer *oneFingerSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeDown:)];
    [oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:oneFingerSwipeDown];
}

- (void)viewDidUnload
{
    [self setImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor: [[self class] colorFromHexString:@"333366"]];
    
    // Initiate get of uploads
    [self.tmbo getUploadswithDelegate:self ofType:@"image"];
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

@end
