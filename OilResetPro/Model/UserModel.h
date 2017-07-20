//
//  UserModel.h
//  OilResetPro
//
//  Created by Asai on 3/29/17.
//  Copyright © 2017 OilResetPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface UserModel : NSObject
@property NSUserDefaults *defaults;

@property long user_id;
@property NSString *user_social_id;
@property NSString *social_token;
@property NSString *social_type;

@property NSString *user_email;
@property NSString *user_password;
@property NSString *user_name;
@property NSString *user_surname;
@property NSString *phone;
@property NSString *photo_url;
@property NSString *user_push_token;
@property NSString *user_pament_status;
@property NSString *auth_token;

+ (UserModel*) getUser;
- (NSString *) getFacebookAccessToken;
- (void) save;
- (void) load;

@end
