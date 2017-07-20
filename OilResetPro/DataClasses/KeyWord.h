//
//  KeyWord.h
//  OilResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#ifndef ORP_KeyWord_h
#define ORP_KeyWord_h

//#define ServerBaseUrl             @"http://htwebdev.com/oilreset/oil.php"
//#define LockedCarsUrl             @"http://htwebdev.com/oilreset/oilunlock.php"


//#define ServerBaseUrl             @"http://oilresetpro.com/oil/oil.php"
//#define LockedCarsUrl             @"http://oilresetpro.com/oil/oilunlock.php"

//#define ServerBaseUrl             @"http://oilresetpro.com/oil/oiltest.php"

#define getallprocedure             @"get-all-procedures"
#define updatebadge                 @"update-user-badge"
#define getallmessage             @"get-all-message"
#define updatemessage             @"update-message"
#define ServerBaseUrl             @"https://oilresetpro.com/oil/data/oil-data.php"
#define LockedCarsUrl             @"http://oilresetpro.com/oil/oilunlock.php"

#define Path @""

#define REVMOB_ID @"52e05b570cf13a1240000003"
#define kInternetError @"Ops, You'r not connected to Internet. Please try again."


#define kInAppKeyUnlockCars    @"Com.UpTopApps.OilResetPro.UnlockCars"
#define kInAppKeyRemoveAds     @"Com.UpTopApps.OilResetPro.RemoveAds"

#define kIntroScreens           @"IntroScreens"
#define kEmailAddress           @"info@oilresetpro.com"
#define kEmailSubject           @"New video submission"

#define kBannerAdUnitId         @"ca-app-pub-6367600362410330/8504027608"
#define kFullAdUnitId           @"ca-app-pub-6367600362410330/5410960404"


#define kAdmobId                @"a1502bdd10991ea"
#define kTestAds                NO

#define kTrackingId             @"UA-49333983-8"

#define XCODE_COLORS_ESCAPE @"\033["

#define koef ([[UIScreen mainScreen] bounds].size.width/375)

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define LogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg37,108,54;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

#define MULTIPLAYER_NUMBER_WORDS 10
#define COINS_TWO_STARS_COMPLETE 10
#define COINS_THREE_STARS_COMPLETE 15

#define kNavigationBarButtonsTitleFontSize 18.0f
#define kNavigationBarButtonsTitleWidthOffset 6.0f
#define kNavigationBarButtonsTitleHeightOffset 3.0f

#define DEBUG_MODE false

#define KOEF [MitimGlobalData getKoef]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBAndAlpha(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_SMALL_IPHONE (IS_IPAD==false && [[UIScreen mainScreen] bounds].size.height == 480.0)
#define IS_SIMULATOR TARGET_OS_SIMULATOR

#define BLUE_COLOR UIColorFromRGB(0x49aacd)
#define APP_COLOR UIColorFromRGBAndAlpha(0x000000, 0.5f)

#define CORNER_RADIUS 10.0

#define AppFont(fontSize) [UIFont systemFontOfSize:fontSize]
#define BoldAppFont(fontSize) [UIFont boldSystemFontOfSize:fontSize]
#define MontserratBoldFont(fontSize) [UIFont fontWithName:@"Montserrat-Bold" size:fontSize]
#define ProximaFont(fontSize) [UIFont fontWithName:@"Proxima Nova" size:fontSize]
#define ProximaFontLight(fontSize) [UIFont fontWithName:@"ProximaNova-Light" size:fontSize]
#define ProximaFontReg(fontSize) [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize]
#define ProximaSemiBoldFont(fontSize) [UIFont fontWithName:@"ProximaNova-Semibold" size:fontSize]
#define AvenirLTStdRoman(fontSize) [UIFont fontWithName:@"AvenirLTStd-Roman" size:fontSize]
#define AvenirLTStdBook(fontSize) [UIFont fontWithName:@"AvenirLTStd-Book" size:fontSize]
#define AvenirLTStdLight(fontSize) [UIFont fontWithName:@"AvenirLTStd-Light" size:fontSize]
#define SantanaBold(fontSize) [UIFont fontWithName:@"Santana-Bold" size:fontSize]
#define Santana(fontSize) [UIFont fontWithName:@"Santana" size:fontSize]
#define SantanaRegularCondensed(fontSize) [UIFont fontWithName:@"Santana-RegularCondensed" size:fontSize]
#define SantanaBlackCondensed(fontSize) [UIFont fontWithName:@"Santana-BlackCondensed" size:fontSize]
#define SantanaXtraCondensed(fontSize) [UIFont fontWithName:@"SantanaXtraCondensed" size:fontSize]
#define SantanaBlack(fontSize) [UIFont fontWithName:@"Santana-Black" size:fontSize]
#define MyriadProRegular(fontSize) [UIFont fontWithName:@"MyriadPro-Regular" size:fontSize]
#define MuseosansFont300(fontSize) [UIFont fontWithName:@"MuseoSans-300" size:fontSize]
#define MuseosansFont500(fontSize) [UIFont fontWithName:@"MuseoSans-500" size:fontSize]
#define MuseosansFont700(fontSize) [UIFont fontWithName:@"MuseoSans-700" size:fontSize]
#define MontserratRegularFont(fontSize) [UIFont fontWithName:@"Montserrat-Regular" size:fontSize]
#define LocationNormal(fontSize) [UIFont fontWithName:@"My Font" size:fontSize]

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(angle) (angle * 180.0 * M_PI)

#define IS_ADMIN [[MitimUser getUser].businessRole isEqualToString:@"ADMIN"]

#define PLATFORM_PASSWORD @"kjasdglkglkjdgkdgkldg"

#define kLocationAskPermission @"LocationAskPermission"
#define kLocationAccessDenied @"LocationAccessDenied"

#define kNotificationDontAllowConnect @"NotificationDontAllowConnectFriends"
#define kNotificationRemoveNoFriendsConnected @"NotificationRemoveNoFriendsConnected"
#define kNotificationUpdatePhoneContact @"NotificationUpdatePhoneContact"
#define commonUtils [CommonUtils shared]


#endif
