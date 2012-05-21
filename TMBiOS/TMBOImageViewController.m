//
//  TMBOImageViewController.m
//  TMBO
//
//  Created by Jim Kelly on 2/9/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import "TMBOImageViewController.h"
#import "TMBO-API.h"

@interface TMBOImage()
@property (weak, nonatomic) NSString *url;
@property (weak, nonatomic) NSArray *comments;
@end

@implementation TMBOImage
@synthesize url = _url;
@synthesize comments = _comments;

- (BOOL)hasUserCommented:(NSString *)userid {
    return NO; 
}

@end


@interface TMBOStream()
@property (strong, nonatomic) NSArray *stream;
@property (nonatomic, strong) NSNumber *currentIndex;
@end

@implementation TMBOStream
@synthesize stream = _stream;
@synthesize currentIndex = _currentIndex;
@synthesize delegate = _delegate;
@synthesize tmbo = _tmbo;

- (void)setStream:(NSArray *)stream {
    if (_stream != stream) {
        _stream = stream;
        [self.delegate reloadData];
    }
}

- (NSArray *)stream {
    if (!_stream) _stream = [[NSArray alloc] init];
    return _stream;
}

- (void)refreshStream {
    dispatch_queue_t streamQueue = dispatch_queue_create("stream_download", NULL);
    dispatch_async(streamQueue, ^{
        
    });
}

- (NSNumber *)currentIndex {
    if (!_currentIndex) _currentIndex = [[NSNumber alloc] initWithInt:0];
    return _currentIndex;
}

@end





@interface TMBOImageViewController()
@property (nonatomic, strong) TMBO_API *tmbo;
@property (nonatomic, strong) NSArray *imageStream;
@end

@implementation TMBOImageViewController

// On-screen objects
@synthesize tIB = _tIB;
@synthesize tIG = _tIG;
@synthesize image = _image;

// Other helper objects
@synthesize imageStream = _imageStream;
@synthesize delegate = _delegate;
@synthesize tmbo = _tmbo;


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
    //self.currentIndex = index;
    //NSLog(@"Viewing image at index %@", self.currentIndex);
    // This should really be pushed into the client-side TMBO API
    //NSString *link_file = [[self.imageStream objectAtIndex:[self.currentIndex integerValue]] objectForKey:@"link_file"];
    
    //NSLog(@"Downloading contents of %@", link_file);
    //[self.image setImage:[self.tmbo getUIImageFromFilePath:link_file]];
    //NSLog(@"done.");
}






- (void)oneFingerSwipeUp:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle swipe left
    //[self viewImageAtIndex:[[NSNumber alloc] initWithInt:[self.currentIndex integerValue] + 1]];
}


- (void)oneFingerSwipeDown:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle swipe left
    //[self viewImageAtIndex:[[NSNumber alloc] initWithInt:[self.currentIndex integerValue] - 1]];
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
