//
//  TMBO-API.m
//  TMBO
//
//  Created by Jim Kelly on 2/8/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import "TMBO-API.h"
#import "HTTPResource.h"

@interface TMBO_API()
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSString *userid;
@end

@implementation TMBO_API

@synthesize delegate = _delegate;
@synthesize userid = _userid;

NSString const *kAPIURI = @"/offensive/api.php";
NSString const *kUSERAGENT = @"TMBiOS %@ (%@) - ponysoft.net (%@/%@ %@)";
 // The return format, can be json, plist, etc.  See API docs for more info.
NSString const *kRETURNFORMAT = @"json";


@synthesize authToken = _authToken;
@synthesize showNSFW = _showNSFW;
@synthesize showTMBO = _showTMBO;


- (BOOL)shouldShowNSFW {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"showNSFW"]) {
        NSString *savedShowNSFW = [prefs stringForKey:@"showNSFW"];
        if (savedShowNSFW == @"NO") {
            _showNSFW = NO;
        } else {
            _showNSFW = YES;
        }
    } else {
        _showNSFW = YES;
    }
    return _showNSFW;
}

- (void)setShowNSFW:(BOOL)showNSFW {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:showNSFW ? @"YES" : @"NO" forKey:@"showNSFW"];
    [prefs synchronize];
    _showNSFW = showNSFW;
}

- (BOOL)shouldShowTMBO {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"showTMBO"]) {
        NSString *savedShowTMBO = [prefs stringForKey:@"showTMBO"];
        if (savedShowTMBO == @"NO") {
            _showTMBO = NO;
        } else {
            _showTMBO = YES;
        }
    } else {
        _showTMBO = YES;
    }
    return _showTMBO;
}

- (void)setShowTMBO:(BOOL)showTMBO {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:showTMBO ? @"YES" : @"NO" forKey:@"showTMBO"];
    [prefs synchronize];
    _showTMBO = showTMBO;
}


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

- (void)vote:(NSString *)vote onUpload:(NSString *)uploadID{
    NSString *voteString = @"novote";
    NSString *subscribe = @"0";
    
    if ([vote isEqualToString:@"-"]) {
        // vote bad
        voteString = @"this%20is%20bad";
        subscribe = @"1";
    } else if ([vote isEqualToString:@"+"]) {
        voteString = @"this%20is%20good";
        subscribe = @"0";
    } else {
        // This should probably throw an error maybe?
    }
    
    NSLog(@"voteString: %@", voteString);
    NSLog(@"subscribe: %@", subscribe);
    
    NSString *TMBOSERVER = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TMBOSERVER"];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@/postcomment.php?fileid=%@&vote=%@&subscribe=%@", TMBOSERVER, kAPIURI, uploadID, voteString, subscribe];
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"Vote URL: %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];

    HTTPResource *httpResource = [[HTTPResource alloc] init];
    [httpResource postToURL:request];
}

- (void)getCommentswithDelegate:(id)delegate onThread:(NSString *)thread byUser:(NSString *)user {
    NSString *TMBOSERVER = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TMBOSERVER"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@/getcomments.%@?userid=%@&thread=%@", TMBOSERVER, kAPIURI, kRETURNFORMAT, user, thread];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];
    HTTPResource *httpResource = [[HTTPResource alloc] init];
    [httpResource getDictionaryFromURL:request withStringSelector:@"getCommentsonThreadbyUserResult:" andDelegate:self];
}

- (void)getCommentsonThreadbyUserResult:(NSDictionary *) result {
    [self.delegate performSelector:@selector(getCommentsonThreadbyUserDidFinish) withObject:result];
}

- (NSNumber *)getFileID:(NSDictionary *)givenUpload {
    return [givenUpload objectForKey:@"id"];
}

- (void)loginWithUsername:(NSString *)username andPassowrd:(NSString *)password withDelegate:(id)delegate {
    self.delegate = delegate;
    NSString *TMBOSERVER = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TMBOSERVER"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@/login.%@?username=%@&password=%@&gettoken=1", TMBOSERVER, kAPIURI, kRETURNFORMAT ,username, password];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    HTTPResource *httpResource = [[HTTPResource alloc] init];
    [httpResource getDictionaryFromURL:request withStringSelector:@"loginWithUsernameResult:" andDelegate:self];
}

- (void)loginWithUsernameResult:(NSDictionary *)result {
    if(result){
        self.authToken = [result objectForKey:@"tokenid"];
        self.userid = [result objectForKey:@"userid"];
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
    
    NSString *tmboURLArg = [[NSString alloc] initWithString:@""];
    if (!self.shouldShowTMBO) {
        tmboURLArg = [[NSString alloc] initWithString:@"&tmbo=0"];
    }
    
    NSString *nsfwURLArg = [[NSString alloc] initWithString:@""];
    if (!self.shouldShowNSFW) {
        nsfwURLArg = [[NSString alloc] initWithString:@"&nsfw=0"];
    }
    
    NSString *TMBOSERVER = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TMBOSERVER"];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@/getuploads.%@?token=%@%@%@", TMBOSERVER, kAPIURI, kRETURNFORMAT, self.authToken, tmboURLArg, nsfwURLArg];
    
    NSLog(@"urlString: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    HTTPResource *httpResource = [[HTTPResource alloc] init];
    [httpResource getDictionaryFromURL:request withStringSelector:@"getUploadsResult:" andDelegate:self];
}


- (void)getUploadswithDelegate:(id)delegate ofType:(NSString *)uploadType {
    self.delegate = delegate;

    NSString *tmboURLArg = [[NSString alloc] initWithString:@""];
    if (!self.shouldShowTMBO) {
        tmboURLArg = [[NSString alloc] initWithString:@"&tmbo=0"];
    }
    
    NSString *nsfwURLArg = [[NSString alloc] initWithString:@""];
    if (!self.shouldShowNSFW) {
        nsfwURLArg = [[NSString alloc] initWithString:@"&nsfw=0"];
    }
    
    NSString *TMBOSERVER = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TMBOSERVER"];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@/getuploads.%@?token=%@&type=%@%@%@", TMBOSERVER, kAPIURI, kRETURNFORMAT, self.authToken, uploadType, tmboURLArg, nsfwURLArg];
    NSLog(@"urlString: %@", urlString);
    
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
    NSString *TMBOSERVER = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TMBOSERVER"];
    NSString *fullLink = [[NSString alloc] initWithFormat:@"%@%@", TMBOSERVER, filePath];
    NSURL *url = [NSURL URLWithString:fullLink];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    return [[UIImage alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];
}


@end





