//
//  YearViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//
#import "YearViewController.h"
#import "MakeViewController.h"
#import "TotalYearsCell.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "ORPDataClass.h"
#import "AllFetchData.h"
#import <RevMobAds/RevMobAds.h>
#import "SettingViewController.h"
#import "SIAlertView.h"
#import "HomeViewController.h"
#import "UserHelper.h"
#import "KxMenu.h"
#import "UIDevice-Helpers.h"
#import "SearchResultCell.h"
#import "JSON.h"
#import "ResetProcedureViewController.h"
#import "KeyWord.h"
#import "AdsCell.h"

@import GoogleMobileAds;


@interface YearViewController ()<GADBannerViewDelegate>{
    IBOutlet GADBannerView *bannerView;
}

@property (nonatomic,strong) GADBannerView *cellBannerView;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation YearViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.screenName = NSStringFromClass([self class]);
    
    [self loadAds:nil];
    
    self.searchDisplayController.searchBar.placeholder = @"Car's Year, Model or  Make";
    array = [[NSMutableArray alloc] init];
    savedArray = [[NSMutableArray alloc] init];
    _SearchResult =[[NSMutableArray alloc]init];
    
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"ic_menu"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionShowSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbar2=[[UIBarButtonItem alloc] init];
    [rightbar2 setCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbar2;
    
    [self setTitle:@"Select Year"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    [_yearsTable setBackgroundColor:[UIColor clearColor]];
    
    
    [_searchBar setHidden: YES];
    _yearsTable.scrollsToTop = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarHit) name:@"touchStatusBarClick" object:nil];
    
    [_yearsTable registerClass:[AdsCell class] forCellReuseIdentifier:@"AdsCell"];
    [self.searchDisplayController.searchResultsTableView registerClass:[SearchResultCell class] forCellReuseIdentifier:@"SearchResultCell"];
//    [self.searchDisplayController.searchResultsTableView setFrame:_yearsTable.frame];
}

- (void) actionMenu:(id)sender{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) actionShowSearch:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{
        if ([_searchBar isHidden]) {
            [_searchBar setHidden:NO];
        }else{
            [_searchBar setHidden:YES];
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    [UIView animateWithDuration:0.5 animations:^{
//        [_searchBar setHidden:YES];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (array.count < 1) {
        [self checkForData];
    }
    else {
        [_yearsTable reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void) statusBarHit {
    [_yearsTable setContentOffset:CGPointZero animated:YES];
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"Home"
                     image:nil
                    target:self
                    action:@selector(home:)],
      
      [KxMenuItem menuItem:@"Setting"
                     image:nil
                    target:self
                    action:@selector(setting:)],
      ];

    KxMenuItem *first = menuItems[0];
    first.alignment = NSTextAlignmentCenter;
    
    CGRect rect = [sender.viewForBaselineLayout convertRect:sender.frame toView:self.view];
    
    [KxMenu showMenuInView:self.view
                  fromRect:rect
                 menuItems:menuItems];
}

#pragma mark - Button Action

- (IBAction)yearbackBtnAction:(id)sender{
    //ORPDataClass *dClass = [ORPDataClass sharedMyData];
    //[dClass._allFetchedDataArray removeAllObjects];
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)topBtnAction:(id)sender{
    [_yearsTable setContentOffset:CGPointZero animated:YES];
}


- (void) setData{
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    NSSet *uniqueStates = [NSSet setWithArray:[dClass._allFetchedDataArray valueForKey:@"_year"]];
    array = [[uniqueStates allObjects] mutableCopy];
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *inOrder=[array sortedArrayUsingDescriptors:descriptors];
    
    [array removeAllObjects];
    [array addObjectsFromArray:inOrder];
    
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.1];
    [_yearsTable reloadData];
}

#pragma mark - Set Frame Without Ads
- (void)setFramesWithoutAds{
    CGRect rect = _yearsTable.frame;
    rect.size.height = self.view.frame.size.height - 70;
    _yearsTable.frame = rect;
}

- (void)setFramesWithAds{
    CGRect rect = _yearsTable.frame;
    rect.size.height = self.view.frame.size.height - 70;
    _yearsTable.frame = rect;
}

#pragma mark ==== Load Ads ====
- (void) loadAds :(id) sender{
    if (self.searchDisplayController.searchResultsTableView.isHidden == false) {
        return;
    }
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
        [self setFramesWithoutAds];
    }
}

#pragma mark GADRequest generation
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad.
    
    request.testDevices = @[kAdmobId];
    
    GADExtras *extras = [[GADExtras alloc] init];
    
    extras.additionalParameters = [NSDictionary dictionaryWithObjectsAndKeys:@"app,cmn_app", @"kw",nil];
    
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
//    category = @"Years";
//    actionString = @"Show Years";
//    
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
//                                                          action:actionString  // Event action (required)
//                                                           label:url          // Event label
//                                                           value:nil] build]];    // Event value
}



- (void) checkForData {
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    if (dClass._allFetchedDataArray.count) {
        [self setData];
    }
    else {
        NSArray *cachedArray = [AllFetchData SQPFetchAllOrderBy:@"year"];
        
        if (cachedArray.count) {
            [dClass._allFetchedDataArray removeAllObjects];
            [dClass._allFetchedDataArray addObjectsFromArray:cachedArray];
            
            [self setData];
        }
        else {
            [self requestForNoOfYears];
        }
    }
    
    if (!dClass.dataLoadedOnThisAppRun) {
        [self requestForNoOfYears];
    }
    
    /*
     NSArray *cachedArray = [AllFetchData SQPFetchAllOrderBy:@"year"];
     
     if (!cachedArray.count && !dClass._allFetchedDataArray.count) {
     [self performSelector:@selector(showHUDWithMessage:) withObject:@"Loading..." afterDelay:0.1];
     [self requestForNoOfYears];
     }
     else {
     if (dClass._allFetchedDataArray.count > cachedArray.count) {
     [self setData];
     }
     else if (cachedArray.count > dClass._allFetchedDataArray.count) {
     [dClass._allFetchedDataArray removeAllObjects];
     [dClass._allFetchedDataArray addObjectsFromArray:cachedArray];
     
     [self setData];
     }
     
     
     [self requestForNoOfYears];
     }
     */
}

- (void) requestForNoOfYears{
    
    
    
    
    //        NSArray *sorted=[savedResponseArray
    //                         sortedArrayUsingComparator:
    //                         ^NSComparisonResult(AllFetchData *first, AllFetchData *second) {
    //                             return [first.year compare:second.year
    //                                                options:0
    //                                                  range:NSMakeRange(0, [second.year length])
    //                                                 locale:locale];
    //                         }];
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    if (!dClass._allFetchedDataArray.count) {
        [self performSelector:@selector(showHUDWithMessage:) withObject:@"Loading..." afterDelay:0.1];
    }
    dClass.dataLoadedOnThisAppRun = YES;
   
    [[ORPNetworkManager sharedManager] GETAllProcedure:getallprocedure data:nil progress:nil completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            
            dClass.dataLoadedOnThisAppRun = NO;
        }else{
            ORPDataClass *dClass = [ORPDataClass sharedMyData];
            
            [AllFetchData loadDataFromJson:data[@"data"]
                       withCompletionBlock:^(NSMutableArray *cars) {
                           if (cars.count > dClass._allFetchedDataArray.count) {
                               [dClass._allFetchedDataArray removeAllObjects];
                               [dClass._allFetchedDataArray addObjectsFromArray:cars];
                               [self setData];
                           }
                       }];

        }
    }];
    
}


- (void) requestForLockedCars{
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    id savedResponse = [defauls objectForKey:@"LockedData"];
    
    if (savedResponse) {
        
        ORPDataClass *dClass = [ORPDataClass sharedMyData];
        NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        NSArray *savedResponseArray = [AllFetchData loadDataFromJsonForLockedCars:savedResponse];
        
        NSArray *sorted = [savedResponseArray
                           sortedArrayUsingComparator:
                           ^NSComparisonResult(AllFetchData *first, AllFetchData *second) {
                               return [first.year compare:second.year
                                                  options:0
                                                    range:NSMakeRange(0, [second.year length])
                                                   locale:locale];
                           }];
        
        [dClass._lockedCarArray removeAllObjects];
        
        for (AllFetchData *data in sorted) {
            if (![dClass._lockedCarArray containsObject:data]) {
                [dClass._lockedCarArray addObject:data];
            }
            
            if (![dClass._allFetchedDataArray containsObject:data]) {
                [dClass._allFetchedDataArray addObject:data];
            }
        }
        
        NSSet *uniqueStates = [NSSet setWithArray:[dClass._allFetchedDataArray valueForKey:@"_year"]];
        array = [[uniqueStates allObjects] mutableCopy];
        
        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
        NSArray *descriptors=[NSArray arrayWithObject: descriptor];
        NSArray *inOrder=[array sortedArrayUsingDescriptors:descriptors];
        
        [array removeAllObjects];
        [array addObjectsFromArray:inOrder];
        [_yearsTable reloadData];
        
    }
    else{
        [self performSelector:@selector(showHUDWithMessage:) withObject:@"Loading..." afterDelay:0.1];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[UserHelper FetchLockedCarsPath] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            [self performSelectorInBackground:@selector(saveLockedCars:) withObject:responseObject];
        }
        
        ORPDataClass *dClass = [ORPDataClass sharedMyData];
        [dClass._allFetchedDataArray addObjectsFromArray:[AllFetchData loadDataFromJsonForLockedCars:responseObject]];
        
        NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        NSArray *sorted=[dClass._allFetchedDataArray sortedArrayUsingComparator:^NSComparisonResult(AllFetchData *first, AllFetchData *second) {
            return [first.year compare:second.year
                               options:0
                                 range:NSMakeRange(0, [second.year length])
                                locale:locale];
        }];
        
        for (AllFetchData *data in sorted) {
            if (![dClass._lockedCarArray containsObject:data]) {
                [dClass._lockedCarArray addObject:data];
            }
            
            if (![dClass._allFetchedDataArray containsObject:data]) {
                [dClass._allFetchedDataArray addObject:data];
            }
        }
        
        [self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.1];
        [self setData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);

    }];
}

#pragma mark - Save In Background
- (void)saveUnLockedCars:(id)arr{
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    dClass._unLockedData = arr;
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    
    if (dClass._unLockedData) {
        [defauls setObject:dClass._unLockedData forKey:@"Data2015"];
    }
    
    [defauls synchronize];
}

- (void)saveLockedCars:(id)arr{
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    dClass._lockedData = arr;
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    
    if (dClass._lockedData) {
        [defauls setObject:dClass._lockedData forKey:@"LockedData"];
    }
    
    [defauls synchronize];
}

#pragma mark - TablView dataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 1;
    NSUInteger count=0;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        bannerView.hidden = YES;
        count = _SearchResult.count;
    }
    else
    {
        bannerView.hidden = NO;
        count =  array.count;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /*
     NSUInteger count=0;
     if (tableView == self.searchDisplayController.searchResultsTableView){
     count = _SearchResult.count;
     return count;
     }
     
     else
     {
     return array.count;
     }
     */
    //    if (section%3==0) {
    //        return 2;
    //    }
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tableView.backgroundColor = [UIColor clearColor];
        return 112;
    }
    else{
        return 60;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        if (indexPath.row == 0) {
            static NSString *simpleTableIdentifier = @"MainItem";
            SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [SearchResultCell loadCell:self];
            }
            AllFetchData *sring = [_SearchResult objectAtIndex:indexPath.section];
            
            cell._modelLbl.text = sring.model;
            cell._modelLbl.textColor = [UIColor colorWithRed:238.0f/255.0f green:232.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
            
            cell._makeLbl.text = sring.make;
            cell._makeLbl.textColor = [UIColor colorWithRed:238.0f/255.0f green:232.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
            
            cell._yearsLbl.text = sring.year;
            cell._yearsLbl.textColor = [UIColor colorWithRed:238.0f/255.0f green:232.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
            
            return cell;
        }
        else if (indexPath.row == 1){
            static NSString *simpleTableIdentifier = @"AdsCell";
            AdsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
            
            //            [cell.bannerView setRootViewController:cell];
            //            cell.bannerView.delegate = self;
            //            [cell.bannerView setAdSize:kGADAdSizeBanner];
            //            cell.bannerView.adUnitID = kBannerAdUnitId;
            
            if (!self.cellBannerView.superview) {
                [self.cellBannerView loadRequest:[self createRequest]];
            }
            
            [cell.contentView addSubview:self.cellBannerView];
            
            //[self.cellBannerView loadRequest:[self createRequest]];
            
            return cell;
        }
        
    }
    else{
        if (indexPath.row == 0) {
            NSString *noOfYears = [array objectAtIndex:indexPath.section];
            
            static NSString *simpleTableIdentifier = @"TotalYearsCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[TotalYearsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            cell.textLabel.text = noOfYears;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = AvenirLTStdLight(40);
            return cell;
        }
        else if (indexPath.row == 1){
            static NSString *simpleTableIdentifier = @"AdsCell";
            
            AdsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [AdsCell loadCell:self];
            }
            
            cell.hidden = NO;
            
            [cell.bannerView setRootViewController:self];
            cell.bannerView.delegate = self;
            [cell.bannerView setAdSize:kGADAdSizeBanner];
            cell.bannerView.adUnitID = kBannerAdUnitId;
            
            [cell.bannerView loadRequest:[self createRequest]];
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        return;
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        ORPDataClass *dClass = [ORPDataClass sharedMyData];
        
        AllFetchData *detail = [_SearchResult objectAtIndex:indexPath.section];
        if (dClass._isUnlockedCar) {
            detail.isLocked = NO;
            ResetProcedureViewController *vc = (ResetProcedureViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ResetProcedureViewController"];
            vc.detail = detail;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (!detail.isLocked){
            ResetProcedureViewController *vc = (ResetProcedureViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ResetProcedureViewController"];
            vc.detail = detail;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        else if (detail.isLocked || !dClass._isUnlockedCar){
            NSString *message = [NSString stringWithFormat:@"Do you want to unlock ALL cars including %@ %@ ?",detail.make,detail.model];
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Message" andMessage:message];
            [alertView addButtonWithTitle:@"NO"
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alertView) {
                                      alertView = nil;
                                  }];
            [alertView addButtonWithTitle:@"YES"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      NSLog(@"OK Clicked");
                                      alertView = nil;
                                      SettingViewController *settingVC = [[SettingViewController alloc] init];
                                      [self.navigationController pushViewController:settingVC animated:YES];
                                  }];
            
            alertView.cornerRadius = 0;
            alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
            alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
            
            alertView.willShowHandler = ^(SIAlertView *alertView) {
            };
            alertView.didShowHandler = ^(SIAlertView *alertView) {
            };
            alertView.willDismissHandler = ^(SIAlertView *alertView) {
            };
            alertView.didDismissHandler = ^(SIAlertView *alertView) {
            };
            
            [alertView show];
            
            //_yearsTable.hidden = NO;
        }
        
        /*
         MakeViewController *make = [[MakeViewController alloc] initWithYear:noOfYears Array:arrayToPass];
         [self.navigationController pushViewController:make animated:YES];*/
        
        //[self.searchDisplayController setActive:NO];
        //[self.searchDisplayController.searchBar resignFirstResponder];
    }
    else{
        
        ORPDataClass *dClass = [ORPDataClass sharedMyData];
        NSString *noOfYears = [array objectAtIndex:indexPath.section];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_year == [cd]%@", noOfYears];
        NSMutableArray *arrayToPass = [[NSMutableArray alloc] init];
        [arrayToPass addObjectsFromArray:[dClass._allFetchedDataArray filteredArrayUsingPredicate:predicate]];
        
//        MakeViewController *make = [[MakeViewController alloc] initWithYear:noOfYears Array:arrayToPass];
        MakeViewController *make = [self.storyboard instantiateViewControllerWithIdentifier:@"MakeViewController"];
        make.getYear = noOfYears;
        make._makesArray = arrayToPass;
        [self.navigationController pushViewController:make animated:YES];
    }
    
    
    //[self performSelectorInBackground:@selector(setAds) withObject:nil];
    
}

#pragma mark - ScrollView Delegae
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

#pragma mark - Search DisplayControllers
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    NSString *string = searchText;
    //    NSError *error = NULL;
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@" " options:NSRegularExpressionCaseInsensitive error:&error];
    //    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    //    NSLog(@"Found %i",numberOfMatches);
    //
    //    if (numberOfMatches == 1) {
    //        searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    }
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"_searchString contains[cd]%@ ",searchText];
    
    NSArray *searchResult = [dClass._allFetchedDataArray filteredArrayUsingPredicate:pred];
    
    [_SearchResult removeAllObjects];
    [_SearchResult addObjectsFromArray:searchResult];
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    //    [dClass._banner hideAd];
    //    [[RevMobAds session] hideBanner];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    _yearsTable.hidden = NO;
    
    
    // [self setAds];
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    if (!dClass._isAdRemovePurcahsed) {
        bannerView.hidden = NO;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    //    [dClass._banner hideAd];
    //    [[RevMobAds session] hideBanner];
    
    //    if (searchBar.text.length > 3) {
    //        [_SearchResult removeAllObjects];
    //    }
    [searchBar resignFirstResponder];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    _searchBar.showsCancelButton = YES;
    
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    if (!dClass._isAdRemovePurcahsed) {
        //        [dClass._banner hideAd];
        //        dClass._isBannerVisible = NO;
        //
        //        [[RevMobAds session] hideBanner];
        
        bannerView.hidden = YES;
    }
}

- (void) searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
    
    _yearsTable.hidden = NO;
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    if (!dClass._isAdRemovePurcahsed) {
        //        [dClass._banner showAd];
        //        dClass._isBannerVisible = YES;
        
        bannerView.hidden = NO;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void) searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    
    _yearsTable.hidden = YES;
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    if (!dClass._isAdRemovePurcahsed) {
        //        [dClass._banner hideAd];
        //        dClass._isBannerVisible = NO;
        
        //        [[RevMobAds session] hideBanner];
        
        bannerView.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

#pragma mark - KeyBoard

- (void)keyboardDidHide:(NSNotification *)notification {
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    
    [tableView setContentInset:UIEdgeInsetsZero];
    
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

#pragma mark - SVProgress HUD
- (void) showHUDWithMessage:(NSString*)message{
    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
}

- (void) hideHUD{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
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
 NSLog(@"Ad Frame Set ");
 
 UIDeviceScreenSize size = [[UIDevice currentDevice] screenSize];
 
 CGRect rect = _yearsTable.frame;
 if (size == UIDeviceScreenSize35Inch) {
 rect.size.height = 360 - 40;
 }
 else {
 rect.size.height = 454 - 40;
 }
 
 _yearsTable.frame = rect;
 }
 
 - (void)revmobUserClickedInTheAd {
 NSLog(@"User clicked in the ad");
 }
 
 - (void)revmobUserClosedTheAd {
 NSLog(@"User closed the ad");
 }*/

#pragma mark - Getter/Setter
- (GADBannerView*)cellBannerView{
    if (!_cellBannerView) {
        _cellBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointMake(0, 0)];
        
        [_cellBannerView setRootViewController:self];
        _cellBannerView.delegate = self;
        [_cellBannerView setAdSize:kGADAdSizeBanner];
        _cellBannerView.adUnitID = kBannerAdUnitId;
    }
    
    return _cellBannerView;
}


@end
