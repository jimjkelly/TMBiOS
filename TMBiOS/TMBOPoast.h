//
//  TMBOPoast.h
//  TMBiOS
//
//  Created by James Kelly on 7/28/12.
//
//

#import <Foundation/Foundation.h>

@interface TMBOPoast : NSObject <NSCoding>
-(id)initWithPoastDict:(NSDictionary *)poastDict;
-(UIImage *)getImage;
-(NSNumber *)getID;
-(NSNumber *)getNumberOfComments;
-(void)cacheImage;
-(void)cacheComments;
-(BOOL)hasBeenSeen;
@end
