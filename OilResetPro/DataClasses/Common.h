//
//  Common.h
//  SomthingLocal
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface Common : NSObject
+ (ASIFormDataRequest*)getPostRequestForUrl:(NSString*)srvrURL withParameters:(NSDictionary*)parameters;
+ (ASIFormDataRequest*)getPostRequestForUrl:(NSString*)srvrURL;
+ (NSString*) getSynchronousServerOutputFor:(NSString *)srvrURL withParameters:(NSDictionary*)parameters;
+ (ASIHTTPRequest*) getRequestForParamtersGet :(NSString*)srvrURL withParameters:(NSDictionary*)parameters;
@end
