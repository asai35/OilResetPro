//
//  SavedResetViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "SavedResetViewController.h"
#import "ResetProcedureViewController.h"
#import "SIAlertView.h"
#import "SettingViewController.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "ORPDataClass.h"
#import "AllFetchData.h"
#import <RevMobAds/RevMobAds.h>
#import "SIAlertView.h"
#import "HomeViewController.h"
#import "UserHelper.h"
#import "KxMenu.h"
#import "UIDevice-Helpers.h"
#import "JSON.h"
#import "ResetProcedureViewController.h"
#import "KeyWord.h"
#import "AdsCell.h"
@interface SavedResetViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation SavedResetViewController

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
    
    UIButton *trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    trashButton.frame = CGRectMake(0, 0, 32, 32);
    [trashButton setImage:[UIImage imageNamed:@"ic_trash"] forState:UIControlStateNormal];
    [trashButton addTarget:self action:@selector(actionTrash:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbar1=[[UIBarButtonItem alloc] init];
    [rightbar1 setCustomView:trashButton];
    self.navigationItem.rightBarButtonItems = @[rightbar1, rightbar2];
    
    [self setTitle:@"Saved Resets"];
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

- (void) actionTrash:(id)sender{
    if ([_tableView isEditing]) {
        [_tableView setEditing:NO animated:YES];
        dataArray = [SaveData allObjects];
        [_tableView reloadData];
    }else{
        [_tableView setEditing:YES animated:YES];
    }
    
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
    [self checkForData];
    dataArray = [SaveData allObjects];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"resetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *dataLabel = [cell viewWithTag:2];
    SaveData *data = [dataArray objectAtIndex:indexPath.row];
    NSString *year = data.year;
    NSString *make = data.make;
    NSString *model = data.model;
    [dataLabel setText:[NSString stringWithFormat:@"%@, %@, %@", year, make, model]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    SaveData *data = [dataArray objectAtIndex:indexPath.row];
    NSString *year = data.year;
    NSString *make = data.make;
    NSString *model = data.model;
    NSMutableArray *arrayToPass = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_model ==[cd] %@", model];
    [arrayToPass addObjectsFromArray:[dClass._allFetchedDataArray filteredArrayUsingPredicate:predicate]];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"_year contains[cd]  %@",year];
    NSArray *searchResult = [arrayToPass filteredArrayUsingPredicate:pred];
    if ([searchResult count] == 0) {
        return;
    }
    AllFetchData *detail = [searchResult objectAtIndex:0];
    
    if (dClass._isUnlockedCar) {
        detail.isLocked = NO;
        ResetProcedureViewController *proce = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetProcedureViewController"];
        proce.selectedMake = make;
        proce.selectedModel = model;
        proce.selectedYear = year;
        proce.detail = detail;
        [self.navigationController pushViewController:proce animated:YES];
    }
    
    else if (!detail.isLocked){
        ResetProcedureViewController *proce = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetProcedureViewController"];
        proce.selectedMake = make;
        proce.selectedModel = model;
        proce.selectedYear = year;
        proce.detail = detail;
        [self.navigationController pushViewController:proce animated:YES];
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
- (void) checkForData {
    ORPDataClass *dClass = [ORPDataClass sharedMyData];

    if (dClass._allFetchedDataArray.count) {
//        [self setData];
    }
    else {
        NSArray *cachedArray = [AllFetchData SQPFetchAllOrderBy:@"year"];

        if (cachedArray.count) {
            [dClass._allFetchedDataArray removeAllObjects];
            [dClass._allFetchedDataArray addObjectsFromArray:cachedArray];

//            [self setData];
        }
        else {
            [self requestForNoOfYears];
        }
    }

    if (!dClass.dataLoadedOnThisAppRun) {
        [self requestForNoOfYears];
    }

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
//                               [self setData];
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
//
//        NSSet *uniqueStates = [NSSet setWithArray:[dClass._allFetchedDataArray valueForKey:@"_year"]];
//        array = [[uniqueStates allObjects] mutableCopy];
//
//        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
//        NSArray *descriptors=[NSArray arrayWithObject: descriptor];
//        NSArray *inOrder=[array sortedArrayUsingDescriptors:descriptors];
//
//        [array removeAllObjects];
//        [array addObjectsFromArray:inOrder];
//        [_yearsTable reloadData];

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
//        [self setData];

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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}


// From Master/Detail Xcode template

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [[RLMRealm defaultRealm] deleteObject:[dataArray objectAtIndex:indexPath.row]];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        dataArray=[SaveData allObjects];
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
    
}

@end
