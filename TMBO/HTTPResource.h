//
//  HTTPResources.h
//  TMBO
//
//  Created by Jim Kelly on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPResource : NSObject
- (void) getDictionaryFromURL:(NSMutableURLRequest *)url withStringSelector:(NSString *) selector andDelegate:(id)delegate;
@end
