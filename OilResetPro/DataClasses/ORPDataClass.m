//
//  ORPDataClass.m
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import "ORPDataClass.h"
#import "SVProgressHUD.h"
#import "KeyWord.h"
#import "NSUserDefaults+AESEncryptor.h"
#import "AppDelegate.h"

@import GoogleMobileAds;

@implementation ORPDataClass
@synthesize _allFetchedDataArray, _globalVar;
@synthesize _inAppProductIdentifier;
@synthesize _isAdRemovePurcahsed,_isUnlockedCar;
@synthesize _lockedCarArray,_unLockedCarArray;
@synthesize _isBannerVisible;
@synthesize _lockedData,_unLockedData;

static  ORPDataClass* _sharedMyData = nil;

+(ORPDataClass*)sharedMyData{
	@synchronized([ORPDataClass class]){
		if (!_sharedMyData)
			_sharedMyData = [[self alloc] init];
		return _sharedMyData;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([ORPDataClass class])
	{
		NSAssert(_sharedMyData == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedMyData = [super alloc];
		return _sharedMyData;
	}
    
	return nil;
}

- (id) init{
    self = [super init];
    _allFetchedDataArray = [[NSMutableArray alloc] init];
    _lockedCarArray  = [[NSMutableArray alloc] init];
    _unLockedCarArray =  [[NSMutableArray alloc] init];
    
//    self._inAppProductIdentifier = [NSSet setWithObjects:kInAppKeyUnlockCars,
//                                                         kInAppKeyRemoveAds,nil];
   
    self._inAppProductIdentifier = [NSSet setWithObjects:kInAppKeyRemoveAds,nil];
    
    
    [self updateINAPPStatusLocal];
    
    if (!_isAdRemovePurcahsed) {
        [RevMobAds startSessionWithAppID:REVMOB_ID];
        
        [RevMobAds session].testingMode = RevMobAdsTestingModeOff;

        [RevMobAds session].testingMode = RevMobAdsTestingModeWithAds;
        
        RevMobAds *revmob = [RevMobAds session];        
        revmob.userGender = RevMobUserGenderMale;
        revmob.userInterests = @[@"cars", @"racing",@"mobile"];
        
//        _banner = [[RevMobAds session] banner];
//        _banner.delegate = self;

        
        [self createAndLoadInterstitial];
    }
    
    return self;
}

#pragma mark - SVProgress HUD
- (void) showHUDWithMessage:(NSString*)message{
    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
}

- (void) hideHUD{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

- (void)updateINAPPStatusLocal{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *statusAdRemoved  = [defaults decryptedValueForKey:kInAppKeyRemoveAds];
   // NSString *statusUnlockCars = [defaults decryptedValueForKey:kInAppKeyUnlockCars];
    
    if (!statusAdRemoved || ![statusAdRemoved isEqualToString:[NSString stringWithFormat:@"%@-YES",kInAppKeyRemoveAds]]) {
        _isAdRemovePurcahsed = NO;
    }
    else {
        _isAdRemovePurcahsed = YES;
//        _fullScreenAd = nil;
//        _banner = nil;
    }
    
    _isUnlockedCar = YES;
    
  /*  if (!statusUnlockCars || ![statusUnlockCars isEqualToString:[NSString stringWithFormat:@"%@-YES",kInAppKeyUnlockCars]]) {
        _isUnlockedCar = NO;
    }
    else {
        _isUnlockedCar = YES;
    }*/
    

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
    _isBannerVisible = YES;
}

- (void)revmobUserClickedInTheAd {
    NSLog(@"User clicked in the ad");
    
    _banner = nil;
    
    _banner = [[RevMobAds session] banner];
    _banner.delegate = self;
    
    [_banner showAd];
}

- (void)revmobUserClosedTheAd {
    NSLog(@"User closed the ad");
}*/

- (void)createAndLoadInterstitial {
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:kFullAdUnitId];
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kAdmobId];
    
    [self.interstitial loadRequest:request];
 //   return self.interstitial;
}

#pragma mark - Ads Full Screen
#pragma mark - Full Screen Ads Delegate
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    [dClass createAndLoadInterstitial];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [dClass.interstitial presentFromRootViewController:delegate.window.rootViewController];
}

@end
