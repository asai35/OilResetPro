//
//  AppDelegate.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "AppDelegate.h"
#import "ORPNetworkManager.h"
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

@import UserNotifications;
#endif

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).

#ifndef NSFoundationVersionNumber_iOS_9_x_Max

#define NSFoundationVersionNumber_iOS_9_x_Max 1299

#endif


@implementation AppDelegate
@synthesize push_token;
@synthesize menuController;
@synthesize messagecount;

NSString *const kGCMMessageIDKey = @"gcm.message_id";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xeeff33), NSFontAttributeName:AvenirLTStdBook(24)}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:YES];
    menuController = [[MEMenuViewController alloc] initWithNibName:@"menuVC" bundle:nil];
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:nil forKey:@"auth_token"];
    [de removeObjectForKey:@"auth_token"];
    [iRate sharedInstance].daysUntilPrompt = 7;
    [iRate sharedInstance].usesUntilPrompt = 15;
    [ORPDataClass sharedMyData];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [GIDSignIn sharedInstance].clientID = kClientID;
    [GIDSignIn sharedInstance].delegate =(id) self;
/*
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
 */
    [self registerForRemoteNotification];

    UserModel *user = [UserModel getUser];
    NSString *access_token = [de objectForKey:@"accessToken"];
    push_token = [de objectForKey:@"push_token"];
    messagecount = (int)[de integerForKey:@"messagecount"];
    if([user.user_social_id isEqualToString:@""]){
        [self loginWithEmail];
    }else if (![access_token isEqualToString:@""]) {
        [self login:[NSString stringWithFormat:@"authenticate-user?email=%@&push_token=%@&social_login=%@&platform=%@&social_type=%@", user.user_email,  push_token, @"gb_gp", @"IOS", user.social_type]];
        
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AuthViewController"];
        [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
    }

    return YES;
    
}

#pragma mark - Remote Notification Delegate // <= iOS 9.x

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"Device Token = %@",strDevicetoken);
    
    push_token = strDevicetoken;
    
    NSLog(@"the generated device token string is : %@",push_token);
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:push_token forKey:@"push_token"];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Push Notification Information : %@",userInfo);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"Push Notification Information : %@",userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
    messagecount = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
    completionHandler(UIBackgroundFetchResultNewData);
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@ = %@", NSStringFromSelector(_cmd), error);
    NSLog(@"Error = %@",error);
}

#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"User Info = %@",notification.request.content.userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ECSlidingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"slideVC"];
    [vc setTopViewController:[storyboard instantiateViewControllerWithIdentifier:@"messageNav"]];
    [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    completionHandler();
}

#pragma mark - Class Methods

/**
 Notification Registration
 */
- (void)registerForRemoteNotification {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (BOOL)application:(UIApplication* )application openURL:(NSURL* )url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ] || [[GIDSignIn sharedInstance] handleURL:url
                                     sourceApplication:sourceApplication
                                            annotation:annotation];
}

- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    
    // Print full message
    
    NSLog(@"%@", remoteMessage.appData);
    
}




- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"active");
    if ([UserModel getUser]) {
        if ([UserModel getUser].user_email) {
            [[ORPNetworkManager sharedManager] POST:updatebadge data:@{@"email": [UserModel getUser].user_email} completion:^(id data, NSError *error) {
                NSLog(@"data = %@", data);
                
            }];
        }
    }
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    [[FIRMessaging messaging] disconnect];
    
    NSLog(@"Disconnected from FCM");
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    
    if (dClass._unLockedData) {
        [defauls setObject:dClass._unLockedData forKey:@"Data"];
    }
    
    if (dClass._lockedData) {
        [defauls setObject:dClass._lockedData forKey:@"LockedData"];
    }
    
    [defauls synchronize];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"OilResetPro"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
- (void) loginToFacebook:(FacebookHandler)handler {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithReadPermissions: @[@"public_profile", @"email"] fromViewController:self.window.rootViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        [self hideHUD];
        if (error) {
        }
        else if (result.isCancelled) {
        }
        else {
        }
        if (handler) handler(result, error);
    }];
}

- (void) loginToFacebookFromViewController:(UIViewController *)vc handler:(FacebookHandler)handler {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithReadPermissions: @[@"public_profile", @"email"] fromViewController:vc handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        [self showHUD];
        if (error) {
           
        }
        else if (result.isCancelled) {
        }
        else {
           
        }
        if (handler) handler(result, error);
    }];
}

- (void) showHUD{
    [SVProgressHUD show];
}

- (void) hideHUD{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}
- (void) loginWithEmail{
    UserModel *cur_user = [UserModel getUser];
    NSString *userEmail = cur_user.user_email;
    NSString *userPassword = cur_user.user_password;
    [self showHUD];
    [[ORPNetworkManager sharedManager] GET:[NSString stringWithFormat:@"authenticate-user?email=%@&password=%@&platform=IOS&push_token=%@", userEmail, userPassword, push_token] data:nil completion:^(id data, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
            NSString *response = data[@"response"];
            if ([response isEqualToString:@"success"]) {
                UserModel *current_User = [UserModel getUser];
                current_User.user_pament_status = data[@"payment_status"];
                current_User.user_name = data[@"first_name"];
                current_User.user_surname = data[@"last_name"];
                current_User.auth_token = data[@"auth_token"];
                current_User.user_email = userEmail;
                current_User.user_password = userPassword;
                current_User.social_type = @"";
                current_User.user_social_id = @"";
                current_User.phone = data[@"phone"];
                current_User.photo_url = data[@"photo_url"];

                [[ORPNetworkManager sharedManager] setAuthToken:data[@"auth_token"]];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ECSlidingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"slideVC"];
                [vc setTopViewController:[storyboard instantiateViewControllerWithIdentifier:@"homeNav"]];
                [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
            }else{
/*                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"authNav"];
                [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
*/
            }
        });
    }];

}

- (void) login: (NSString*)parameters{
    
    [[ORPNetworkManager sharedManager] GET:parameters data:nil completion:^(id data, NSError *error) {
        
            NSString *response = data[@"response"];
            if ([response isEqualToString:@"success"]) {
                UserModel *current_User = [UserModel getUser];
                current_User.user_pament_status = data[@"payment_status"];
                current_User.auth_token = data[@"auth_token"];
                [current_User save];
                current_User.phone = data[@"phone"];
                current_User.photo_url = data[@"photo_url"];
                [[ORPNetworkManager sharedManager] setAuthToken:data[@"auth_token"]];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ECSlidingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"slideVC"];
                [vc setTopViewController:[storyboard instantiateViewControllerWithIdentifier:@"homeNav"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHUD];
                    [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];

                });
            }else{
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AuthViewController"];
//                [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
                
            }
    }];
    
}


@end
AppDelegate *appdelegate(void){
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
