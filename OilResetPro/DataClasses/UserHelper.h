//
//  UserHelper.h
//  SomthingLocal
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "ASIFormDataRequest.h"
//#import "ASIHTTPRequest.h"
//#import "KeyWord.h"

@interface UserHelper : NSObject

//+(ASIFormDataRequest*) AllCategories :(NSDictionary*)parameters;
+(NSString*) FetchDataPath;
+(NSString*) FetchLockedCarsPath;

+ (void) showError:(NSString*)error withMessage:(NSString*)message;
+ (void) showErrorWithMessage:(NSString*)error :(NSString*)message;
+ (BOOL) validateEmail:(NSString*)email;
@end
