//
//  UserHelper.m
//  SomthingLocal
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import "UserHelper.h"
#import "Common.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "KeyWord.h"
#import "LMAlertView.h"
@implementation UserHelper


+(NSString*) FetchDataPath{
    NSString *requestpath = [NSString stringWithFormat:@"%@",ServerBaseUrl];
    return requestpath;
}

+(NSString*) FetchLockedCarsPath{
    NSString *requestpath = [NSString stringWithFormat:@"%@",LockedCarsUrl];
    return requestpath;
}

#pragma mark - Show Error

+ (void) showError:(NSString*)error withMessage:(NSString*)message{
    LMAlertView *alertView = [[LMAlertView alloc] initWithTitle:error message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void) showErrorWithMessage:(NSString*)error :(NSString*)message{
    LMAlertView *alertView = [[LMAlertView alloc] initWithTitle:error message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (BOOL) validateEmail:(NSString*)email{
    NSString *emailRegEx =
    
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[cd] %@", emailRegEx];
    
    if ( ! [regExPredicate evaluateWithObject:email] ) {
        return NO;
    }
    else
        return YES;
}

@end
