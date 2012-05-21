//
//  TMBiOSViewController.m
//  TMBiOS
//
//  Created by Jim Kelly on 5/17/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import "TMBiOSViewController.h"

@interface TMBiOSViewController ()

@end

@implementation TMBiOSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
