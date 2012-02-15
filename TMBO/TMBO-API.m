//
//  TMBO-API.m
//  TMBO
//
//  Created by Jim Kelly on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TMBO-API.h"
#import "HTTPResource.h"

@interface TMBO_API()
@property (nonatomic, assign) id delegate;
@end

@implementation TMBO_API

@synthesize delegate = _delegate;

NSString const *kAPIURL = @"https://thismight.be/offensive/api.php";
NSString const *kUSERAGENT = @"TMBiOS %@ (%@) - ponysoft.net (%@/%@ %@)";
 // The return format, can be json, plist, etc.  See API docs for more info.
NSString const *kRETURNFORMAT = @"json";


@synthesize authToken = _authToken;
@synthesize showNSFW = _showNSFW;
@synthesize showTMBO = _showTMBO;


- (NSString *)authToken {
    if (_authToken == nil) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedAuthToken = [prefs stringForKey:@"authToken"];
        if (savedAuthToken) {
            _authToken = savedAuthToken;
        }
    }
    
    return _authToken;
}

- (void)setAuthToken:(NSString *)authToken {
    // First save our auth token
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:authToken forKey:@"authToken"];
    [prefs synchronize];
    _authToken = authToken;
}

- (NSString *)getUserAgent {
    return [[NSString alloc] initWithFormat:kUSERAGENT, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
}

- (void)loginWithUsername:(NSString *)username andPassowrd:(NSString *)password withDelegate:(id)delegate {
    self.delegate = delegate;
    //NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%@%@%@%@%@%@", kAPIURL, @"login.", kRETURNFORMAT ,"?username=", username, @"&password=", password, @"&gettoken=1"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/login.%@?username=%@&password=%@&gettoken=1", kAPIURL, kRETURNFORMAT ,username, password];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    HTTPResource *httpResource = [[HTTPResource alloc] init];
    [httpResource getDictionaryFromURL:request withStringSelector:@"loginWithUsernameResult:" andDelegate:self];
    
}

- (void)loginWithUsernameResult:(NSDictionary *)result {
    if(result){
        self.authToken = [result objectForKey:@"tokenid"];
        [self.delegate performSelector: @selector(loginConnectionDidFinish:) withObject:[NSNumber numberWithBool:YES]];
    } else {
        [self.delegate performSelector: @selector(loginConnectionDidFinish:) withObject:[NSNumber numberWithBool:NO]];
    }

}

- (void)loginFailed {
    // pass login failures up to delegate
    [self.delegate performSelector:@selector(loginFailed)];
}

- (void)logout {
    self.authToken = nil;
}

- (void)getUploadswithDelegate:(id)delegate {
    self.delegate = delegate;
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/getuploads.%@?token=%@&", kAPIURL, kRETURNFORMAT, self.authToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    HTTPResource *httpResource = [[HTTPResource alloc] init];
    [httpResource getDictionaryFromURL:request withStringSelector:@"getUploadsResult:" andDelegate:self];
}


- (void)getUploadswithDelegate:(id)delegate ofType:(NSString *)uploadType {
    self.delegate = delegate;
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/getuploads.%@?token=%@&type=%@", kAPIURL, kRETURNFORMAT, self.authToken, uploadType];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];

    HTTPResource *httpResource = [[HTTPResource alloc] init];
    [httpResource getDictionaryFromURL:request withStringSelector:@"getUploadsResult:" andDelegate:self];
}

- (void)getUploadsResult:(NSDictionary *)result {
    [self.delegate performSelector: @selector(getUploadsDidFinish:) withObject:result];
}

- (UIImage *)getUIImageFromFilePath:(NSString *)filePath {
    NSString *fullLink = [[NSString alloc] initWithFormat:@"http://thismight.be%@", filePath];
    NSURL *url = [NSURL URLWithString:fullLink];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    return [[UIImage alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];
}



@end





