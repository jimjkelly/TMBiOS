//
//  TMBOImageViewController.m
//  TMBO
//
//  Created by Jim Kelly on 2/9/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import "TMBOImageViewController.h"
#import "TMBO-API.h"
#import "TMBOStream.h"

@interface TMBOImageViewController()
@property (nonatomic, strong) TMBO_API *tmbo;
@property (nonatomic, strong) TMBOStream *tmboStream;
@end

@implementation TMBOImageViewController

// On-screen objects
@synthesize tIB = _tIB;
@synthesize tIG = _tIG;
@synthesize image = _image;

// Other helper objects
@synthesize delegate = _delegate;
@synthesize tmbo = _tmbo;
@synthesize tmboStream = _tmboStream;

- (TMBO_API *)tmbo {
    if (!_tmbo) _tmbo = [[TMBO_API alloc] init];
    return _tmbo;
}

- (TMBOStream *)tmboStream {
    if (!_tmboStream) _tmboStream = [[TMBOStream alloc] init];
    return _tmboStream;
}

- (void) enableVoteButtons {
    // Not sure why we'd use this necessarily, but hey, why not
    [self.tIG setEnabled:YES];
    [self.tIG setAlpha:1.0];
    [self.tIB setEnabled:YES];
    [self.tIB setAlpha:1.0];
}

- (void) disableVoteButtons:(NSString *) showVote {
    [self.tIG setEnabled:NO];
    [self.tIB setEnabled:NO];
    
    if (!showVote) {
        [self.tIG setAlpha:0.4];
        [self.tIB setAlpha:0.4];
    } else if ([showVote isEqualToString:@"-"]) {
        [self.tIG setAlpha:0.0];
        [self.tIB setAlpha:0.4];        
    } else if ([showVote isEqualToString:@"+"]) {
        [self.tIG setAlpha:0.4];
        [self.tIB setAlpha:0.0];
    }
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
    //NSString *vote = sender.currentTitle;
    //NSNumber *fileID = [self.tmbo getFileID:[self.imageStream objectAtIndex:[self.currentIndex integerValue]]];
    
    //[self disableVoteButtons:vote];
    //[self.tmbo vote:vote onUpload:[[NSString alloc] initWithFormat:@"%d", [fileID intValue]]];
}

- (void)loginFailed {
    // do stuffs for a login failure.  What's a login failure doing here?
    // if our authToken is invalidated, this could happpen.  Kick us
    // back to the login screen.  In the future we may want to consider
    // providing a message about why this happened.
    NSLog(@"Login no longer accepted, kicking back to login screen");
    [self performSegueWithIdentifier:@"ImagesToLogin" sender:self];
}

- (void)viewCurrentImageOn:(NSNotification *)notification {
    NSLog(@"About to show initial image");
    [self.image setImage:[self.tmboStream getCurrentImage]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)oneFingerSwipeUp:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle swipe left
    //[self viewImageAtIndex:[[NSNumber alloc] initWithInt:[self.currentIndex integerValue] + 1]];
    [self.image setImage:[self.tmboStream getNextImage]];
}

- (void)oneFingerSwipeDown:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle swipe left
    [self.image setImage:[self.tmboStream getPreviousImage]];
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
    
    // Initiate get of uploads, having it pass back to the tmboStream object,
    // and add a notification to show the current image once loaded
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewCurrentImageOn:)
                                                 name:@"TMBOStreamLoaded" object:self.tmboStream];
    [self.tmbo getUploadswithDelegate:self.tmboStream ofType:@"image"];
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
