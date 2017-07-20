//
//  AppDelegate.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MEMenuViewController.h"
#define  kClientID @"544372944604-us3o446a08g7gasrjo8g7jtf8a433p8i.apps.googleusercontent.com"

typedef void (^FacebookHandler)(FBSDKLoginManagerLoginResult *result, NSError *error);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, assign) BOOL isVideoPlaying;
@property (nonatomic) int messagecount;

@property (nonatomic, strong) MEMenuViewController *menuController;
@property NSString *push_token;

- (void)saveContext;

- (void) loginToFacebook:(FacebookHandler)handler;
- (void) loginToFacebookFromViewController:(UIViewController *)vc handler:(FacebookHandler)handler;

@end
AppDelegate *appdelegate(void);

