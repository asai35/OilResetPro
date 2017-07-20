//
//  ORPDataClass.h
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORPDataClass.h"
//#import <RevMobAds/RevMobAds.h>

@import GoogleMobileAds;

@interface ORPDataClass : NSObject{
    NSMutableArray *_allFetchedDataArray;
    NSString *_globalVar;
}

+(ORPDataClass*)sharedMyData;

@property (nonatomic, strong) NSMutableArray *_allFetchedDataArray;
@property (nonatomic, strong) NSMutableArray *_lockedCarArray;
@property (nonatomic, strong) NSMutableArray *_unLockedCarArray;
@property (nonatomic, strong) NSString *_globalVar;
@property (nonatomic, strong) NSSet *_inAppProductIdentifier;
@property (nonatomic, assign) BOOL _isAdRemovePurcahsed;
@property (nonatomic, assign) BOOL _isUnlockedCar;
@property (nonatomic, assign) BOOL _isBannerVisible;
//@property (nonatomic, strong) RevMobBanner *_banner;
//@property (nonatomic, strong) RevMobFullscreen *_fullScreenAd;
@property (nonatomic, strong) id _lockedData;
@property (nonatomic, strong) id _unLockedData;

- (void) showHUDWithMessage:(NSString*)message;
- (void) hideHUD;

- (void)updateINAPPStatusLocal;

@property(nonatomic, strong) GADInterstitial *interstitial;
- (void)createAndLoadInterstitial;

@property(nonatomic, assign) BOOL dataLoadedOnThisAppRun;

@end
