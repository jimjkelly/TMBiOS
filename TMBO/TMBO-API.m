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
NSString const *kUSERAGENT = @"TMBiOS - ponysoft.net";
 // The return format, can be json, plist, etc.  See API docs for more info.
NSString const *kRETURNFORMAT = @"json";


@synthesize authToken = _authToken;


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



- (void)loginWithUsername:(NSString *)username andPassowrd:(NSString *)password withDelegate:(id)delegate {
    self.delegate = delegate;
    //NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%@%@%@%@%@%@", kAPIURL, @"login.", kRETURNFORMAT ,"?username=", username, @"&password=", password, @"&gettoken=1"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/login.%@?username=%@&password=%@&gettoken=1", kAPIURL, kRETURNFORMAT ,username, password];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:kUSERAGENT forHTTPHeaderField:@"User-Agent"];
    
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


- (void)getUploadswithDelegate:(id)delegate {
    self.delegate = delegate;
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/getuploads.%@?token=%@&", kAPIURL, kRETURNFORMAT, self.authToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:kUSERAGENT forHTTPHeaderField:@"User-Agent"];
    
    HTTPResource *httpResource = [[HTTPResource alloc] init];
    [httpResource getDictionaryFromURL:request withStringSelector:@"getUploadsResult:" andDelegate:self];
}


- (void)getUploadswithDelegate:(id)delegate ofType:(NSString *)uploadType {
    self.delegate = delegate;
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/getuploads.%@?token=%@&type=%@", kAPIURL, kRETURNFORMAT, self.authToken, uploadType];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:kUSERAGENT forHTTPHeaderField:@"User-Agent"];

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
    [request setValue:kUSERAGENT forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    return [[UIImage alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];
}


/*- (void)getUIImagewithDelegate:(id)delegate fromURL:(NSString *)urlString {
    self.delegate = delegate;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:kUSERAGENT forHTTPHeaderField:@"User-Agent"];
    
    UIImage *image = [UIImage alloc] initWithData:[NSData dataWithContentsOfURL:request];
    [NSData data
    
    [self.delegate performSelector: @selector(getUIImageDidFinish:) withObject:image];
}*/





@end





