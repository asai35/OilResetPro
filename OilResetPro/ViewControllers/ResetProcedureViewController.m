//
//  ResetProcedureViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "ResetProcedureViewController.h"

#import "HomeViewController.h"
#import "ORPDataClass.h"
#import "AllFetchData.h"
#import <RevMobAds/RevMobAds.h>
#import "SettingViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "KxMenu.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "KeyWord.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@import GoogleMobileAds;

@interface ResetProcedureViewController ()<GADBannerViewDelegate,GADInterstitialDelegate>{
    IBOutlet GADBannerView *bannerView;
    RLMResults *resultsArray;
    SaveData *selectedDataObject;

    AVPlayerViewController *videoController;
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@property (nonatomic,weak) IBOutlet UIButton *shareBtn;
@property (nonatomic,weak) IBOutlet UIButton *watchVideoBtn;
@property (nonatomic,weak) IBOutlet UIButton *submitVideoBtn;
@property (strong, nonatomic) IBOutlet UILabel *lblWatchVideo;
@property (nonatomic,strong) NSString *videoId;
@property (nonatomic,weak) IBOutlet UIView *cotentView;

@end

@implementation ResetProcedureViewController
@synthesize detail;
@synthesize selectedMake, selectedYear, selectedModel;

- (void) initWithReset{
    
    carDetail = detail.reset;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\r+" options:0 error:NULL];
    NSString *newString = [regex stringByReplacingMatchesInString:carDetail options:0 range:NSMakeRange(0, [carDetail length]) withTemplate:@"\n\n"];
    
    setResetData = newString;
    video = detail.video;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initWithReset];
//    self.screenName = NSStringFromClass([self class]);
    
    resetArray = [[NSMutableArray alloc] init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.backBarButtonItem=barButton;
    
    

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionShowSearch:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightbar2=[[UIBarButtonItem alloc] init];
    [rightbar2 setCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbar2;

    [self setTitle:@"Reset Procedure"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    _baseTextView.text = setResetData;
    _baseTextView.textColor = [UIColor whiteColor];
    
    
    
    if ([video isEqualToString:@"none"]) {
        _watchVideoBtn.hidden = YES;
        _lblWatchVideo.hidden = YES;
    }
    else{
        _watchVideoBtn.hidden = NO;
        _lblWatchVideo.hidden = NO;
        _videoId = [self extractYoutubeIdFromLink:video];
    }
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    if (!dClass._isAdRemovePurcahsed) {
        dClass.interstitial.delegate = self;
        
        if ([dClass.interstitial isReady]){
            [dClass.interstitial presentFromRootViewController:self];
        }
    }

}
- (void) actionMenu:(id)sender{
//    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) actionShowSearch:(id)sender{
    [appdelegate().menuController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [appdelegate().menuController tableView:appdelegate().menuController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNav"];
    [self.slidingViewController resetTopViewAnimated:YES];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _first.selected = YES;
    
    [self loadAds:nil];
    
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
    selectedDataObject = [[SaveData alloc] init];
    resultsArray =[SaveData allObjects];
    for (SaveData *data in resultsArray) {
        if ([data.year isEqual:selectedYear] && [data.make isEqual:selectedMake] && [data.model isEqual:selectedModel]) {
            [_submitVideoBtn setSelected:YES];
            selectedDataObject = data;
        }
    }
    
    
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    //    [dClass._fullScreenAd hideAd];
    //    dClass._fullScreenAd = nil;
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"Home"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(home:)],
      
      [KxMenuItem menuItem:@"Setting"
                     image:nil
                    target:self
                    action:@selector(setting:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.alignment = NSTextAlignmentCenter;
    
    CGRect rect = [sender.viewForLastBaselineLayout convertRect:sender.frame toView:self.view];
    [KxMenu showMenuInView:self.view
                  fromRect:rect
                 menuItems:menuItems];
}

- (void) home:(id)sender
{
    BOOL isFound = NO;
    NSArray *viewConArray = self.navigationController.viewControllers;
    for (id viewcon in viewConArray) {
        if ([viewcon isKindOfClass:[YearViewController
                                    class]]) {
            [self.navigationController popToViewController:viewcon animated:YES];
            //[self.navigationController setNavigationBarHidden:YES];
            isFound = YES;
            break;
        }
    }
    
    if (!isFound) {
        YearViewController *homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"YearViewController"];
        [self.navigationController pushViewController:homeVc animated:YES];
        //[self.navigationController setNavigationBarHidden:YES];
    }
    
    
}


- (void) setting:(id)sender
{
    SettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void) setData{
    
    NSSet *uniqueStates = [NSSet setWithArray:[resetArray valueForKey:@"_model"]];
    array = [[uniqueStates allObjects] mutableCopy];
}

# pragma mark - Button Action

- (IBAction)basebackBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingBtnAction:(id)sender{
    SettingViewController *setting = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:setting animated:YES];
}

- (IBAction)shareBtnPressed:(id)sender{
    // oilrestPro.jpeg
    NSURL *Url = [NSURL URLWithString:@"http://onelink.to/r4t9jy"];
    [self shareUrl:Url andImage:[UIImage imageNamed:@"oilrestPro.jpeg"]];
}

- (IBAction)watchVideoBtnPressed:(id)sender{
    
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:_videoId];
    //[self presentMoviePlayerViewControllerAnimated:videoPlayerViewController animated:YES completion:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerFinishPlaybackNotification:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.isVideoPlaying = YES;
    [self presentViewController:videoPlayerViewController animated:YES completion:^{
        
    }];
//    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
}

//- (void) showVideo:(NSURL *) videoUrl {
//    AVPlayer *player = [AVPlayer playerWithURL:videoUrl];
//
//    videoController = [[AVPlayerViewController alloc] init];
//    videoController.showsPlaybackControls = true;
//    videoController.player = player;
//    videoController.player.automaticallyWaitsToMinimizeStalling= YES;
//    [player play];
//    
//    [self presentViewController:videoController animated:YES completion:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:selfselector:@selector(videoDidFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:[videoController.player currentItem]];
//    
//}
//-(void)videoDidFinish:(NSNotification *)notification{
//
//    [videoController dismissViewControllerAnimated:YEScompletion:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:selfname:AVPlayerItemDidPlayToEndTimeNotification object:[videoController.player currentItem]];
//}
- (IBAction)submitVideoBtnPressed:(id)sender{
/*    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setToRecipients:[NSArray arrayWithObjects:kEmailAddress, nil]];
    [mailViewController setSubject:kEmailSubject];
    
    [self presentViewController:mailViewController animated:YES completion:nil];
    */
    if ([_submitVideoBtn isSelected]) {
        [_submitVideoBtn setSelected:NO];
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [[RLMRealm defaultRealm] deleteObject:selectedDataObject];
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }else{
        [_submitVideoBtn setSelected:YES];
        [self insertDataIntoDataBaseWithName:selectedYear make:selectedMake model:selectedModel];
    }
}
-(void)insertDataIntoDataBaseWithName:(NSString *)year make:(NSString *)make model:(NSString *)model
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    SaveData *information = [[SaveData alloc] init];
    information[@"year"]=year;
    information[@"make"]=make;
    information[@"model"]=model;
    [realm addObject:information];
    selectedDataObject = information;
    [realm commitWriteTransaction];
}

- (IBAction)firstBtnAction:(id)sender{
    
    _first.selected =YES;
    _second.selected =NO;
    _third.selected =NO;
    
    [_baseView setHidden:NO];
    [_multiFuncVuew setHidden:YES];
    [_naviView setHidden:YES];
    
}

#pragma mark ==== Extract videoId from YouTube Url ====
- (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array1 = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array1.count > 0) {
        NSTextCheckingResult *result = array1.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ==== Share Method ====
- (void)shareUrl:(NSURL *)url andImage:(UIImage *)image
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (url) {
        [sharingItems addObject:url];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - Set Frame Without Ads
- (void)setFramesWithoutAds{
    CGRect rect = self.cotentView.frame;
    rect.size.height = self.view.frame.size.height - 70;
    self.cotentView.frame = rect;
    
}

- (void)setFramesWithAds{
    CGRect rect = self.cotentView.frame;
    rect.size.height = self.view.frame.size.height - 70;
    self.cotentView.frame = rect;
}

#pragma mark ==== Load Ads ====
- (void) loadAds :(id) sender{
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    if (!dClass._isAdRemovePurcahsed) {
        [bannerView setRootViewController:self];
        
        bannerView.delegate = self;
        [bannerView setAdSize:kGADAdSizeBanner];
        bannerView.adUnitID = kBannerAdUnitId;
        
        [bannerView loadRequest:[self createRequest]];
        
        bannerView.hidden = YES;
        [self setFramesWithoutAds];
    }
    else {
        bannerView.hidden = YES;
        [self setFramesWithoutAds];
    }
}

#pragma mark GADRequest generation
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad.
    
    request.testDevices = @[kAdmobId];
    GADExtras *extras = [[GADExtras alloc] init];
    
    extras.additionalParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"app,cmn_app", @"kw",
                                   nil];
    
    [request registerAdNetworkExtras:extras];
    
    return request;
}

#pragma mark GADBannerViewDelegate impl
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
    bannerView.hidden = NO;
    
    [self setFramesWithAds];
}

- (void)adView:(GADBannerView *)viewdidFailToReceiveAdWithError :(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}


#pragma mark ==== Google Analytics ====
-(void)setEventsForGoogleAnalyticsWithUrl:(NSString*)url{
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    NSString *category,*actionString;
//    
//    category = @"Detail";
//    actionString = @"Show Detail";
//    
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
//                                                          action:actionString  // Event action (required)
//                                                           label:url          // Event label
//                                                           value:nil] build]];    // Event value
}

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
 
 UIDeviceScreenSize size = [[UIDevice currentDevice] screenSize];
 
 CGRect rect = self.cotentView.frame;
 if (size == UIDeviceScreenSize35Inch) {
 rect.size.height = 321 - 40;
 }
 else {
 rect.size.height = 407 - 40;
 }
 
 self.cotentView.frame = rect;
 }
 
 - (void)revmobUserClickedInTheAd {
 NSLog(@"User clicked in the ad");
 }
 
 - (void)revmobUserClosedTheAd {
 NSLog(@"User closed the ad");
 
 UIDeviceScreenSize size = [[UIDevice currentDevice] screenSize];
 
 CGRect rect = self.cotentView.frame;
 if (size == UIDeviceScreenSize35Inch) {
 rect.size.height = rect.size.height + 40;
 }
 else {
 rect.size.height = rect.size.height + 40;
 }
 
 self.cotentView.frame = rect;
 }*/



#pragma mark ==== MFMaail method =====
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSent:
            
            break;
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - NS Notification
- (void)moviePlayerFinishPlaybackNotification:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        delegate.isVideoPlaying = NO;
        
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    });
}
@end
