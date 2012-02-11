//
//  HTTPResources.m
//  TMBO
//
//  Created by Jim Kelly on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HTTPResource.h"

@interface HTTPResource()
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, assign) id delegate;
@property (nonatomic, weak) NSString *selector;
@end


@implementation HTTPResource

@synthesize responseData = _responseData;
@synthesize selector = _selector;
@synthesize delegate = _delegate;

- (NSMutableData *)responseData {
    if (_responseData == nil) _responseData = [[NSMutableData alloc] init];
    return _responseData;
}

- (void) getDictionaryFromURL:(NSMutableURLRequest *)url withStringSelector:(NSString *) selector andDelegate:(id)delegate {
    self.delegate = delegate;
    self.selector = selector;
    
    [[NSURLConnection alloc] initWithRequest:url delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error;
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&error];
    NSLog( @"result is %@", result);
    
    [self.delegate performSelector: NSSelectorFromString(self.selector) withObject:result];
}

@end
