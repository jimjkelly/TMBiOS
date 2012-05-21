//
//  TMBO-API.h
//  TMBO
//
//  Created by Jim Kelly on 2/8/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBO_API : NSObject
@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, assign, getter=shouldShowTMBO) BOOL showTMBO;
@property (nonatomic, assign, getter=shouldShowNSFW) BOOL showNSFW;
- (NSNumber *)getFileID:(NSDictionary *)givenUpload;
- (void)vote:(NSString *)vote onUpload:(NSString *)uploadID;
- (void)loginWithUsername:(NSString *)username andPassowrd:(NSString *)password withDelegate:(id)delegate;
- (void)logout;
- (void)getUploadswithDelegate:(id)delegate;
- (void)getUploadswithDelegate:(id)delegate ofType:(NSString *)uploadType;
- (void)getCommentswithDelegate:(id)delegate onThread:(NSString *)thread byUser:(NSString *)user;
- (UIImage *)getUIImageFromFilePath:(NSString *)request;
@end
