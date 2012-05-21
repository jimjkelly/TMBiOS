//
//  HTTPResources.m
//  TMBO
//
//  Created by Jim Kelly on 2/11/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
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

- (void) postToURL:(NSMutableURLRequest *)url {
    // The upstream request doesn't care about getting more information
    self.delegate = nil;
    self.selector = nil;
    
    [[NSURLConnection alloc] initWithRequest:url delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responseData setLength:0];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    // We probably need to more aggressively interpret codes here
    if (httpResponse.statusCode == 401) {
        // login failure, cancel the connection and call
        // delegate's failure
        [connection cancel];
        NSLog(@"Login failure");
        // TODO: This creates the interesting scenario where something like
        // a vote fails because we aren't logged in, but the user doesn't
        // know why.
        if (self.delegate) {
            [self.delegate performSelector:@selector(loginFailed)];
        }
    }
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
    //NSLog( @"result is %@", result);

    if (self.selector) {
        [self.delegate performSelector: NSSelectorFromString(self.selector) withObject:result];

    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
