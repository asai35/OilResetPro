//
//  ModelViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "ModelViewController.h"

#import "ResetProcedureViewController.h"
#import "HomeViewController.h"
#import "ModelCell.h"
#import "AllFetchData.h"
#import "ORPDataClass.h"
#import <RevMobAds/RevMobAds.h>
#import "SettingViewController.h"
#import "SearchResultCell.h"
#import "SIAlertView.h"
#import "UserHelper.h"
#import "KxMenu.h"
#import "KeyWord.h"



@interface ModelViewController ()<GADBannerViewDelegate>{
    BOOL addReceived;
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation ModelViewController
@synthesize _setData, _selectedMake, _selectedYear, _modelsArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.screenName = NSStringFromClass([self class]);
    
    self.searchDisplayController.searchBar.placeholder = @"Car's Year, Model or  Make";
    
    getArray = [[NSMutableArray alloc] init];
    _SearchResult =[[NSMutableArray alloc]init];
    _setArray = [[NSMutableArray alloc] init];
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.backBarButtonItem=barButton;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionShowSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbar2=[[UIBarButtonItem alloc] init];
    [rightbar2 setCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbar2;
    
    [self setTitle:@"Model"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    [self setData];
    [_searchBar setHidden: YES];
    
    [[SIAlertView appearance] setMessageFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance] setTitleColor:[UIColor colorWithRed:113.0f/255.0f green:95.0f/255.0f blue:93.0f/255.0f alpha:1.0f]];
    [[SIAlertView appearance] setMessageColor:[UIColor colorWithRed:113.0f/255.0f green:95.0f/255.0f blue:93.0f/255.0f alpha:1.0f]];
    
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor whiteColor]];
    
    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setCancelButtonColor:[UIColor whiteColor]];
    
    [[SIAlertView appearance] setDefaultButtonImage:[[UIImage imageNamed:@"alert-box"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,9,6)] forState:UIControlStateNormal];
    
    [[SIAlertView appearance] setCancelButtonImage:[[UIImage imageNamed:@"alert-box"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,9,6)] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarHit) name:@"touchStatusBarClick" object:nil];
    
    _modelTableView.scrollsToTop = YES;
    addReceived = NO;
//    [self.searchDisplayController.searchResultsTableView setFrame:_modelTableView.frame];
}
- (void) actionMenu:(id)sender{
//    [self.slidingViewController anchorTopViewToRightAnimated:YES];
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
    _yearLbl.text = _selectedYear;
    _yearLbl.textColor = [UIColor whiteColor];
    _makeLbl.text = _selectedMake;
    _makeLbl.textColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.5 animations:^{
//        [_searchBar setHidden:YES];
    }];
    [self loadAds:nil];
}

- (void) statusBarHit {
    [_modelTableView setContentOffset:CGPointZero animated:YES];
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

- (IBAction) home:(id)sender
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


- (IBAction) setting:(id)sender
{
    SettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void) setData{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"_year contains[cd]  %@",_selectedYear];
    NSArray *searchResult = [_modelsArray filteredArrayUsingPredicate:pred];
    
    NSSet *uniqueStates = [NSSet setWithArray:[searchResult valueForKey:@"_model"]];
    _setArray = [[uniqueStates allObjects] mutableCopy];
    
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    for (NSString *str in _setArray) {
        if (![str isKindOfClass:[NSString class]]) {
            NSString *convert = [NSString stringWithFormat:@"%d",[str intValue]];
            [arr2 addObject:convert];
        }
        
        else{
            [arr2 addObject:str];
        }
    }
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *inOrder=[arr2 sortedArrayUsingDescriptors:descriptors];
    
    [_setArray removeAllObjects];
    [_setArray addObjectsFromArray:inOrder];
    [_modelTableView reloadData];
}
//
#pragma mark - Set Frame Without Ads
- (void)setFramesWithoutAds{
    CGRect rect = _modelTableView.frame;
    rect.size.height = self.view.frame.size.height - 130;
    _modelTableView.frame = rect;
}

- (void)setFramesWithAds{
    CGRect rect = _modelTableView.frame;
    rect.size.height = self.view.frame.size.height - 170;
    _modelTableView.frame = rect;
}
//
#pragma mark ==== Load Ads ====
- (void) loadAds :(id) sender{
    if (searchDisplayController.searchResultsTableView.isHidden == false) {
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
    
//    [self setFramesWithAds];
}

- (void)adView:(GADBannerView *)viewdidFailToReceiveAdWithError :(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

#pragma mark ==== Google Analytics ====
-(void)setEventsForGoogleAnalyticsWithUrl:(NSString*)url{
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    NSString *category,*actionString;
//    
//    category = @"Model";
//    actionString = @"Show Model";
//    
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
//                                                          action:actionString  // Event action (required)
//                                                           label:url          // Event label
//                                                           value:nil] build]];    // Event value
}


/*
 - (void)setAds{
 ORPDataClass *dClass = [ORPDataClass sharedMyData];
 
 if (dClass._isAdRemovePurcahsed) {
 [dClass._banner hideAd];
 [[RevMobAds session] hideBanner];
 }
 else {
 if (!dClass._isBannerVisible) {
 [self revmobAdDisplayed];
 }
 
 if (!_modelTableView.hidden){
 dClass._banner = [[RevMobAds session] banner];
 dClass._banner.delegate = self;
 [dClass._banner showAd];
 }
 else{
 [dClass._banner hideAd];
 }
 }
 
 //    if (self.searchDisplayController.isActive) {
 //        [_modelTableView setHidden:YES];
 //    }
 //    else{
 //        [_modelTableView setHidden:NO];
 //    }
 }*/

# pragma mark - Button Action

- (IBAction)modelbackBtnAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)topBtnAction2:(id)sender{
    [_modelTableView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)settingMBtnAction:(id)sender{
    SettingViewController *setting = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:setting animated:YES];
}

#pragma mark - TablView dataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count=0;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        count = _SearchResult.count;
        bannerView.hidden = YES;
        return count;
    }
    
    else
    {
        bannerView.hidden = NO;
        return _setArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tableView.backgroundColor = [UIColor clearColor];
        return 114;
    }
    else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        
        static NSString *simpleTableIdentifier = @"SearchResultCell";
        SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [SearchResultCell loadCell:self];
        }
        
        AllFetchData *sring = [_SearchResult objectAtIndex:indexPath.row];
        
        cell._modelLbl.text = sring.model;
        cell._modelLbl.textColor = [UIColor whiteColor];
        
        cell._makeLbl.text = sring.make;
        cell._makeLbl.textColor = [UIColor whiteColor];
        
        cell._yearsLbl.text = sring.year;
        cell._yearsLbl.textColor = [UIColor whiteColor];
        
        return cell;
    }
    
    else{
        NSString *model =[_setArray objectAtIndex:indexPath.row];
        static NSString *simpleTableIdentifier = @"ModelCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        if (![model isKindOfClass:[NSString class]]) {
            NSString *convert = [NSString stringWithFormat:@"%d",[model intValue]];
            cell.textLabel.text = convert;
        }else{
            cell.textLabel.text = model;
        }
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = AvenirLTStdLight(40);
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        ORPDataClass *dClass = [ORPDataClass sharedMyData];
        /*
         NSString *selectedResult = [_SearchResult objectAtIndex:indexPath.row];
         
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_searchString == [cd]%@", selectedResult];
         NSMutableArray *arrayToPass = [[NSMutableArray alloc] init];
         [arrayToPass addObjectsFromArray:[dClass._allFetchedDataArray filteredArrayUsingPredicate:predicate]];*/
        AllFetchData *detail = [_SearchResult objectAtIndex:indexPath.row];
        
        if (dClass._isUnlockedCar) {
            detail.isLocked = NO;
            ResetProcedureViewController *make = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetProcedureViewController"];
            make.detail = detail;
            make.selectedYear = _selectedYear;
            make.selectedMake = _selectedMake;
            [self.navigationController pushViewController:make animated:YES];
        }
        
        else if (!detail.isLocked){
            ResetProcedureViewController *make = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetProcedureViewController"];
            make.detail = detail;
            //[make setAddRecieved:addReceived];
            //            if (!dClass._isBannerVisible) {
            //              [dClass._banner hideAd];
            //              // dClass._banner = nil;
            //            }
            //            [[RevMobAds session] hideBanner];
            [self.navigationController pushViewController:make animated:YES];
            
        }
        
        else if (detail.isLocked || !dClass._isUnlockedCar){
            NSString *message = [NSString stringWithFormat:@"Do you want to unlock ALL cars including %@ %@ ?",
                                 detail.make,
                                 detail.model];
            
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Message" andMessage:message];
            [alertView addButtonWithTitle:@"NO"
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alertView) {
                                      
                                  }];
            [alertView addButtonWithTitle:@"YES"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      NSLog(@"OK Clicked");
                                      
                                      SettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
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
        }
        
        //[self.searchDisplayController setActive:NO];
        //[self.searchDisplayController.searchBar resignFirstResponder];
    }
    
    else{
        ORPDataClass *dClass = [ORPDataClass sharedMyData];
        
        NSString *_modelName = [_setArray objectAtIndex:indexPath.row];
        NSMutableArray *arrayToPass = [[NSMutableArray alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_model ==[cd] %@", _modelName];
        [arrayToPass addObjectsFromArray:[dClass._allFetchedDataArray filteredArrayUsingPredicate:predicate]];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"_year contains[cd]  %@",_selectedYear];
        NSArray *searchResult = [arrayToPass filteredArrayUsingPredicate:pred];
        
        AllFetchData *detail = [searchResult objectAtIndex:0];
        
        if (dClass._isUnlockedCar) {
            detail.isLocked = NO;
            ResetProcedureViewController *make = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetProcedureViewController"];
            make.detail = detail;
            make.selectedYear = _selectedYear;
            make.selectedMake = _selectedMake;
            make.selectedModel = _modelName;
            [self.navigationController pushViewController:make animated:YES];
        }
        
        else if (!detail.isLocked){
            ResetProcedureViewController *make = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetProcedureViewController"];
            make.detail = detail;
            //[make setAddRecieved:addReceived];
            //                ORPDataClass *dClass = [ORPDataClass sharedMyData];
            //                [dClass._banner hideAd];
            
            //          if (!dClass._isBannerVisible) {
            //            [dClass._banner hideAd];
            //           // dClass._banner = nil;
            //          }
            //          [[RevMobAds session] hideBanner];
            make.selectedYear = _selectedYear;
            make.selectedMake = _selectedMake;
            make.selectedModel = _modelName;
            [self.navigationController pushViewController:make animated:YES];
        }
        
        else if (detail.isLocked || !dClass._isUnlockedCar){
            NSString *message = [NSString stringWithFormat:@"Do you want to unlock ALL cars including %@ %@ ?",
                                 detail.make,
                                 detail.model];
            
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Message" andMessage:message];
            [alertView addButtonWithTitle:@"NO"
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alertView) {
                                      
                                  }];
            [alertView addButtonWithTitle:@"YES"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      NSLog(@"OK Clicked");
                                      
                                      SettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
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
        }
    }
}

#pragma mark - ScrollView Delegae
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

#pragma mark - Search DisplayControllers
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"_searchString contains[cd] %@",searchText];
    
    NSArray *searchResult = [dClass._allFetchedDataArray filteredArrayUsingPredicate:pred];
    //    NSSet *uniqueStates = [NSSet setWithArray:[searchResult valueForKey:@"_searchString"]];
    //    NSMutableArray  *arraySearch = [[uniqueStates allObjects] mutableCopy];
    
    [_SearchResult removeAllObjects];
    [_SearchResult addObjectsFromArray:searchResult];
    [_modelTableView reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //    if (searchBar.text.length > 3) {
    //        [_SearchResult removeAllObjects];
    //    }
    
    [searchBar resignFirstResponder];
    
    //    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    //    [dClass._banner hideAd];
    //    [[RevMobAds session] hideBanner];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    _modelTableView.hidden = NO;
    
    [self loadAds:nil];
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    if (!dClass._isAdRemovePurcahsed) {
        bannerView.hidden = NO;
    }
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
    _modelTableView.hidden = NO;
    
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
    _modelTableView.hidden = YES;
    
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    if (!dClass._isAdRemovePurcahsed) {
        //        [dClass._banner hideAd];
        //        dClass._isBannerVisible = NO;
        //
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
 
 UIDeviceScreenSize size = [[UIDevice currentDevice] screenSize];
 
 CGRect rect = _modelTableView.frame;
 if (size == UIDeviceScreenSize35Inch) {
 rect.size.height = 320 - 40;
 }
 else {
 rect.size.height = 406 - 40;
 }
 addReceived = YES;
 _modelTableView.frame = rect;
 
 }
 
 - (void)revmobUserClickedInTheAd {
 NSLog(@"User clicked in the ad");
 }
 
 - (void)revmobUserClosedTheAd {
 NSLog(@"User closed the ad");
 }*/
@end
