//
//  VinliDetailViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "VinliDetailViewController.h"
#import "ResetProcedureViewController.h"
#import "DeviceTrackCell.h"
#import "SIAlertView.h"
#import "SettingViewController.h"
@interface VinliDetailViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation VinliDetailViewController
@synthesize deviceDataArray;
@synthesize deviceId;
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
    [rightButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionShowSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbar2=[[UIBarButtonItem alloc] init];
    [rightbar2 setCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbar2;
    
    [self setTitle:@"Vinli Detail"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}
- (void) actionMenu:(id)sender{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) actionShowSearch:(id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[ORPNetworkManager sharedManager] GETVinliData:[NSString stringWithFormat:@"get-vinli-vehicles?device_id=%@",deviceId] data:nil progress:nil completion:^(id data, NSError *error) {
        
        deviceDataArray = data[@"vehicles"];
        [_tblDetailVinli reloadData];
    }];
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
    

    
}
- (void) vinlidetailbackBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) logOut:(id) sender{
    [VLSessionManager logOut];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    //    return 1 + ((_deviceList != nil) ? _deviceList.count : 0);
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return deviceDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"DeviceTrackCell";
    DeviceTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DeviceTrackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *device = [deviceDataArray objectAtIndex:indexPath.row];
    if (![device[@"make"] isKindOfClass:[NSNull class]]) {
        cell.lblMake.text = device[@"make"];;
    }
    if (![device[@"model"] isKindOfClass:[NSNull class]]) {
        cell.lblModel.text = device[@"model"];;
    }
    if (![device[@"year"] isKindOfClass:[NSNull class]]) {
        cell.lblYear.text = device[@"year"];;
    }
    cell.lblMake.textColor = [UIColor whiteColor];
    cell.lblModel.textColor = [UIColor whiteColor];
    cell.lblYear.textColor = [UIColor whiteColor];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    NSDictionary *device = [deviceDataArray objectAtIndex:indexPath.row];
    NSString *_modelName = device[@"model"];
    NSMutableArray *arrayToPass = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_model ==[cd] %@", _modelName];
    [arrayToPass addObjectsFromArray:[dClass._allFetchedDataArray filteredArrayUsingPredicate:predicate]];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"_year contains[cd]  %@",device[@"year"]];
    NSArray *searchResult = [arrayToPass filteredArrayUsingPredicate:pred];
    
    if ([searchResult count] > 0) {
        AllFetchData *detail = [searchResult objectAtIndex:0];
        if (dClass._isUnlockedCar) {
            detail.isLocked = NO;
            ResetProcedureViewController *make = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetProcedureViewController"];
            make.detail = detail;
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

- (void) clearCookies{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}


@end
