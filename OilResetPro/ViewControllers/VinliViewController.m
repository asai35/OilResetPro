//
//  VinliViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "VinliViewController.h"
#import "secrets.h"
#import "DeviceCell.h"
#import "VinliDetailViewController.h"
#define USER_SECTION 0

#define FIRST_NAME_ROW 0
#define LAST_NAME_ROW 1
#define EMAIL_ROW 2
#define PHONE_ROW 3

#define DEVICE_NAME_ROW 0
#define LATEST_VEHICLE_ROW 1
#define LATEST_LOCATION_ROW 2
#define STREAM_ROW 3

#define DEFAULT_VALUE -10101

@interface VinliViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) VLService *vlService;

@property (strong, nonatomic) NSMutableArray<VLDevice *> *deviceList;
@property (strong, nonatomic) VLUser *user;
@property (strong, nonatomic) NSMutableDictionary<NSString *, VLVehicle *> *latestVehicleMap;
@property (strong, nonatomic) NSMutableDictionary<NSString *, VLLocation *> *latestLocationMap;
@property (strong, nonatomic) VLStream *stream;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation VinliViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    [self setTitle:@"Use Vinli"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    if([VLSessionManager loggedIn]){
        _vlService = [[VLService alloc] initWithSession:[VLSessionManager currentSession]];
        [self fetchUserAndDevices];
    }else{ // If we aren't logged in, we need to login.
        [self loginWithVinli];
    }
    
}
- (void) actionMenu:(id)sender{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) actionShowSearch:(id)sender{
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
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
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // Stop the stream if our view controller disappears.
    [self stopStream];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) resetDataStructures{
    _deviceList = [[NSMutableArray alloc] init];
    _user = nil;
    _latestVehicleMap = [[NSMutableDictionary alloc] init];
    _latestLocationMap = [[NSMutableDictionary alloc] init];
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
                                 }else{
                                     NSLog(@"Error logging in: %@", [error localizedDescription]);
                                 }
                             } onCancel:^{ // Called if the user presses the 'Cancel' button
                                 NSLog(@"Canceled login");
                             }];
}

- (void) fetchUserAndDevices{
    [self showHUD:@"Loading..."];
    [self resetDataStructures];
    
    // Get the current user logged in with Vinli
    [_vlService getUserOnSuccess:^(VLUser *user, NSHTTPURLResponse *response) {
        _user = user;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error fetching user: %@", bodyString);
    }];
    
    // Get the first page of the user's devices.
    [_vlService getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
        });
        [_deviceList addObjectsFromArray:devicePager.devices];
        [self.tblDevices reloadData];
        [self fetchLatestVehicles];
        [self fetchLatestLocations];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
        });
        NSLog(@"Error fetching devices: %@", bodyString);
    }];
}

// We want the latest vehicle for each device.
- (void) fetchLatestVehicles{
    for(int i = 0; i < _deviceList.count; i++){
        VLDevice *device = [_deviceList objectAtIndex:i];
        [_vlService getLatestVehicleForDeviceWithId:device.deviceId onSuccess:^(VLVehicle *vehicle, NSHTTPURLResponse *response) {
            if(vehicle != nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHUD];
                });
                [_latestVehicleMap setObject:vehicle forKey:device.deviceId];
                [self.tblDevices reloadData];
            }
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
            });
            NSLog(@"Error getting latest vehicle for device %@: %@", device.deviceId, bodyString);
        }];
    }
}

// We want the latest location for each device.
- (void) fetchLatestLocations{
    for(int i = 0; i < _deviceList.count; i++){
        VLDevice *device = [_deviceList objectAtIndex:i];
        // We set limit to be 1 since we only want the most recent location
        [_vlService getLocationsForDeviceWithId:device.deviceId limit:@1 until:nil since:nil sortDirection:nil onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
            });
            if(locationPager.locations.count > 0){
                [_latestLocationMap setObject:locationPager.locations.firstObject forKey:device.deviceId];
//                [self.tblDevices reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:LATEST_LOCATION_ROW inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                [self.tblDevices reloadData];
            }
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
            });
            NSLog(@"Error getting latest location for device %@: %@", device.deviceId, bodyString);
        }];
    }
}

- (void) stopStream{
    if(_stream != nil){
        [_stream disconnect];
        _stream = nil;
    }
}


- (void) logOut:(id) sender{
    [VLSessionManager logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectDevice:(id)sender {
}


#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1 + ((_deviceList != nil) ? _deviceList.count : 0);
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _deviceList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 50;
   
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"DeviceCell";
    DeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    VLDevice *device = [_deviceList objectAtIndex:(indexPath.row)];
    cell.deviceName.text = device.name;
    cell.deviceName.textColor = [UIColor whiteColor];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VLDevice *device = [_deviceList objectAtIndex:indexPath.row];
    NSLog(@"Starting stream for device: %@", device.deviceId);
    VinliDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VinliDetailViewController"];
    vc.deviceId = device.deviceId;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void) clearCookies{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}
- (void) showHUD:(NSString*)message{
    [SVProgressHUD show];
}

- (void) hideHUD{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}


@end
