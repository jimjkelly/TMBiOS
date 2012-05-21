//
//  HTTPResources.h
//  TMBO
//
//  Created by Jim Kelly on 2/11/12.
//  Copyright (c) 2012 PonySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPResource : NSObject
- (void) postToURL:(NSMutableURLRequest *)url;
- (void) getDictionaryFromURL:(NSMutableURLRequest *)url withStringSelector:(NSString *) selector andDelegate:(id)delegate;
@end
