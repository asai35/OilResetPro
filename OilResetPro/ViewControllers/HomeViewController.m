//
//  HomeViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2014 OilResetPro. All rights reserved.
//

#import "HomeViewController.h"
#import "secrets.h"
#import "VinliViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"

@interface HomeViewController ()
{
    IBOutlet GADBannerView *bannerView;

}
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"ic_menu"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionShowSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbar2=[[UIBarButtonItem alloc] init];
    [rightbar2 setCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbar2;
    
    [self setTitle:@"Home"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;

    NSDictionary *transitionData = self.transitions.all[3];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.slidingViewController.delegate = nil;
    } else {
        self.slidingViewController.delegate = transition;
    }

    NSString *transitionName = transitionData[@"name"];
    if ([transitionName isEqualToString:METransitionNameDynamic]) {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
        self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
        self.slidingViewController.customAnchoredGestures = @[];
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }


}
#pragma mark - Properties

- (METransitions *)transitions {
    if (_transitions) return _transitions;

    _transitions = [[METransitions alloc] init];

    return _transitions;
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;

    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];

    return _dynamicTransitionPanGesture;
}


- (void) actionMenu:(id)sender{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) actionShowSearch:(id)sender{
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]]) {
        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
        if (!self.dynamicTransitionPanGesture) {
            self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
        }
        
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    if (dClass._isAdRemovePurcahsed) {
        //[dClass._banner hideAd];
        // [[RevMobAds session] hideBanner];
    }
    else {
        //        if (!dClass._isBannerVisible) {
        //            [dClass._banner showAd];
        //        }
    }
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
- (IBAction)loginVinli:(id)sender {
    [self loginWithVinli];
}
- (void) loginWithVinli{
    // Clear cookies before calling loginWithClientId
    [self clearCookies];
    
    // This will launch the Vinli login flow.
    [VLSessionManager loginWithClientId:CLIENT_ID // Get your app client id at dev.vin.li
                            redirectUri:REDIRECT_URI // Get your app redirect uri at dev.vin.li
                             completion:^(VLSession * _Nullable session, NSError * _Nullable error) { // Called if the user successfully logs in, or if there is an error
                                 if(!error){
                                     NSLog(@"Logged in successfully");
                                     UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VinliViewController"];
                                     [self.navigationController pushViewController:vc animated:YES];
                                 }else{
                                     NSLog(@"Error logging in: %@", [error localizedDescription]);
                                 }
                             } onCancel:^{ // Called if the user presses the 'Cancel' button
                                 NSLog(@"Canceled login");
                             }];
}

- (void) logOutWithVinli{
    [VLSessionManager logOut];
}

- (void) clearCookies{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (void)fillUserInfo
{
    RevMobAds *revmob = [RevMobAds session];
    
    revmob.userGender = RevMobUserGenderFemale;
    revmob.userAgeRangeMin = 18;
    revmob.userAgeRangeMax = 21;
    revmob.userBirthday = [NSDate dateWithTimeIntervalSince1970:0];
    revmob.userPage = @"twitter.com/revmob";
    revmob.userInterests = @[@"mobile", @"iPhone", @"apps"];
    
}

-(void) loadIntroScreens{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault boolForKey:kIntroScreens]) {
        [self showIntroWithCrossDissolve];
        
        [userDefault setBool:YES forKey:kIntroScreens];
        [userDefault synchronize];
    }
}

#pragma mark ==== Show Intro ====
- (void)showIntroWithCrossDissolve {
    
    
}

- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex {
    
    
    if (pageIndex == 3) {
        [introView.skipButton setBackgroundImage:[UIImage imageNamed:@"btn-done"] forState:UIControlStateNormal];
    }
    
    else{
        [introView.skipButton setBackgroundImage:[UIImage imageNamed:@"btn-skip"] forState:UIControlStateNormal];
    }
}


#pragma mark - Button Action

- (IBAction)selectVehicle:(id)sender{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    //    UINavigationController *navafterLogin =[[UINavigationController alloc] initWithRootViewController:afterLVC];
    //    navafterLogin.navigationBar.translucent= NO;
    
    //[self presentViewController:navafterLogin animated:YES completion:nil];
    
    
    [self performSelector:@selector(navigate) withObject:self afterDelay:0.3];
    
//    [self performSegueWithIdentifier:@"yearSegue" sender:self];
}

- (void)navigate{
    
    YearViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YearViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - RevMob Delegate
 - (void)revmobAdDidFailWithError:(NSError *)error {
 NSLog(@"Ad failed with error: %@", error);
 }
 
 - (void)revmobAdDidReceive {
 NSLog(@"Ad loaded successfullly");
 }
 
 - (void)revmobAdDisplayed {
 NSLog(@"Ad displayed");
 }
 
 - (void)revmobUserClickedInTheAd {
 NSLog(@"User clicked in the ad");
 }
 
 - (void)revmobUserClosedTheAd {
 NSLog(@"User closed the ad");
 }*/

@end
