//
//  TMBOPoast.h
//  TMBiOS
//
//  Created by James Kelly on 7/28/12.
//
//

#import <Foundation/Foundation.h>

@interface TMBOPoast : NSObject
@property (nonatomic, strong) NSNumber *postid;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, assign) Boolean *nsfw;
@property (nonatomic, assign) Boolean *tmbo;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) Boolean *subscribed;
@property (nonatomic, strong) NSNumber *vote_good;
@property (nonatomic, strong) NSNumber *vote_bad;
@property (nonatomic, strong) NSNumber *vote_tmbo;
@property (nonatomic, strong) NSNumber *vote_repost;
@property (nonatomic, strong) NSNumber *comments;
@property (nonatomic, strong) NSNumber *filtered;
@end
