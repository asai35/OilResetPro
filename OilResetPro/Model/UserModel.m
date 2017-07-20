//
//  UserModel.m
//  OilResetPro
//
//  Created by Asai on 3/29/17.
//  Copyright © 2017 OilResetPro. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize defaults;

UserModel* currentUser;
+ (UserModel*) getUser {
    if (currentUser == NULL){
        currentUser = [[UserModel alloc] init];
    }
    [currentUser load];
    return currentUser;
}
-(void)save{
    defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.user_push_token forKey:@"user_push_token"];
    [defaults setObject:self.user_email forKey:@"user_email"];
    [defaults setObject:self.user_password forKey:@"user_password"];
    [defaults setObject:self.user_name forKey:@"user_name"];
    [defaults setObject:self.user_surname forKey:@"user_surname"];
    [defaults setObject:self.user_social_id forKey:@"user_social_id"];
    [defaults setObject:self.social_token forKey:@"social_token"];
    [defaults setObject:self.social_type forKey:@"social_type"];
    [defaults setObject:self.user_pament_status forKey:@"user_pament_status"];
    [defaults setObject:self.auth_token forKey:@"auth_token"];
    if (self.phone) {
        [defaults setObject:self.phone forKey:@"phone"];
    }else{
        [defaults setObject:@"" forKey:@"phone"];
    }
    if (self.photo_url) {
        [defaults setObject:self.photo_url forKey:@"photo_url"];
    }else{
        [defaults setObject:@"" forKey:@"photo_url"];
    }
    [defaults synchronize];

}

-(void)load{
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.user_email = [defaults objectForKey:@"user_email"];
    self.user_password = [defaults objectForKey:@"user_password"];
    self.user_name = [defaults objectForKey:@"user_name"];
    self.user_surname = [defaults objectForKey:@"user_surname"];
    self.user_push_token = [defaults objectForKey:@"user_push_token"];
    self.user_social_id = [defaults objectForKey:@"user_social_id"];
    self.social_token = [defaults objectForKey:@"social_token"];
    self.social_type = [defaults objectForKey:@"social_type"];
    self.user_pament_status = [defaults objectForKey:@"user_pament_status"];
    self.auth_token = [defaults objectForKey:@"auth_token"];
    if ([defaults objectForKey:@"phone"]) {
        self.phone = [defaults objectForKey:@"phone"];
    }else{
        self.phone = @"";
    }
    if ([defaults objectForKey:@"photo_url"]) {
        self.photo_url = [defaults objectForKey:@"photo_url"];
    }else{
        self.photo_url = @"";
    }
    [defaults synchronize];
}

- (NSString *) getFacebookAccessToken {
    if ([FBSDKAccessToken currentAccessToken]) {
        self.social_type = [FBSDKAccessToken currentAccessToken].tokenString;
        return [FBSDKAccessToken currentAccessToken].tokenString;
    }
    return self.social_type;
}


@end
