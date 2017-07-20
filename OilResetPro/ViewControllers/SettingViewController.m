//
//  SettingViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "SettingViewController.h"
#import "HomeViewController.h"
#import "CargoBay.h"
#import "ORPDataClass.h"
#import "KxMenu.h"
#import "KeyWord.h"
#import "SVProgressHUD.h"
#import "NSUserDefaults+AESEncryptor.h"
#import "YearViewController.h"
#import "IntroPageViewController.h"

@interface SettingViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation SettingViewController
@synthesize _productIdentifier,_purchasedIdentifier;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionShowSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbar2=[[UIBarButtonItem alloc] init];
    [rightbar2 setCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbar2;
    
    [self setTitle:@"Settings"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    _products = [[NSMutableArray alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"IAPHelperProductPurchasedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productFailedPurchasd:) name:@"IAPHelperProductFailedNotification" object:nil];
    
    //IAPHelperProductPurchasedNotification
    //IAPHelperProductFailedNotification
    
    [self setViewData];
    
    [self reload];
}

- (void) actionMenu:(id)sender{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) actionShowSearch:(id)sender{
    [appdelegate().menuController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [appdelegate().menuController tableView:appdelegate().menuController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNav"];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Controller Methods
- (void) setViewData{
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    /*if (dClass._isUnlockedCar) {
     UIImage *img = [UIImage imageNamed:@"btn-unlockcar-1"];
     [_btnUnlock setImage:img forState:UIControlStateNormal];
     [_btnUnlock setImage:img forState:UIControlStateHighlighted];
     }
     else {
     UIImage *img = [UIImage imageNamed:@"btn-unlockcar"];
     [_btnUnlock setImage:img forState:UIControlStateNormal];
     [_btnUnlock setImage:img forState:UIControlStateHighlighted];
     }*/
    
    if (dClass._isAdRemovePurcahsed) {
        UIImage *img = [UIImage imageNamed:@"btn-removeads-1"];
        [_btnRemoveAds setImage:img forState:UIControlStateNormal];
        [_btnRemoveAds setImage:img forState:UIControlStateHighlighted];
        
    }
    else {
        UIImage *img = [UIImage imageNamed:@"btn-removeads"];
        [_btnRemoveAds setImage:img forState:UIControlStateNormal];
        [_btnRemoveAds setImage:img forState:UIControlStateHighlighted];
    }
    
}

- (void)showSettingMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"Home"
                     image:nil
                    target:self
                    action:@selector(home:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.alignment = NSTextAlignmentCenter;
    CGRect rect = [sender.viewForLastBaselineLayout convertRect:sender.frame toView:self.view];
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
            isFound = YES;
            break;
        }
    }
    
    if (!isFound) {
        YearViewController *homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"YearViewController"];
        
        [self.navigationController pushViewController:homeVc animated:YES];
    }
}

#pragma mark - In Appp Purchase Methods
- (void)reload {
    // ORPDataClass *dClass = [ORPDataClass sharedMyData];
    
    // [dClass performSelector:@selector(showHUDWithMessage:) withObject:@"Loading..." afterDelay:0.0];
    
    _products = nil;
    [[IAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
        }
        //[dClass performSelector:@selector(hideHUD) withObject:nil afterDelay:0.1];
    }];
}

- (void)productPurchased:(NSNotification *)notification {
    ORPDataClass *dClass = [ORPDataClass sharedMyData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [notification userInfo];
    SKPaymentTransaction *transaction = [userInfo objectForKey:@"transaction"];
    
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            // purchased. show as playable
            *stop = YES;
            if ([[vComp objectAtIndex:0] intValue] >= 7) {
                NSData *transactionReciept = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                //[self requestForDownload:transactionReciept];
            }
            else if ([[vComp objectAtIndex:0] intValue] <= 6) {
                //[self requestForDownload:transaction.transactionReceipt];
            }
            
            /*if ([transaction.payment.productIdentifier isEqualToString:kInAppKeyUnlockCars]) {
             NSString *stringFormat = [NSString stringWithFormat:@"%@-YES",kInAppKeyUnlockCars];
             [defaults encryptValue:stringFormat withKey:kInAppKeyUnlockCars];
             }
             else */
            if ([transaction.payment.productIdentifier isEqualToString:kInAppKeyRemoveAds]){
                NSString *stringFormat = [NSString stringWithFormat:@"%@-YES",kInAppKeyRemoveAds];
                [defaults encryptValue:stringFormat withKey:kInAppKeyRemoveAds];
            }
            
            [defaults synchronize];
            
            [SVProgressHUD dismiss];
            [dClass updateINAPPStatusLocal];
            // Set Status On Top
            [self setViewData];
        }
    }];
}

- (void)productFailedPurchasd:(NSNotification*)notification{
    NSString * productIdentifier = [NSString stringWithFormat:@"%@ \nPlease try again.",notification.object];;
    
    [SVProgressHUD dismiss];
    
    LMAlertView *alertView = [[LMAlertView alloc] initWithTitle:@"Oops"
                                                        message:productIdentifier
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
}

#pragma mark - Button Action

- (IBAction)settingBackBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)removeAd:(id)sender{
    _productIdentifier = kInAppKeyRemoveAds;
    
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:_productIdentifier]) {
            *stop = YES;
            
            [[IAPHelper sharedInstance] buyProduct:product];
            [self performSelector:@selector(showHUDWithMessage:) withObject:@"Purchasing..." afterDelay:0.0];
        }
    }];
}

- (IBAction)watchIntroBtnPressed:(id)sender{
    
    IntroPageViewController *introPage = [self.storyboard instantiateViewControllerWithIdentifier:@"introVC"];

    [self.navigationController pushViewController:introPage animated:YES];
    
    
    /*_productIdentifier = kInAppKeyUnlockCars;
     
     [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
     if ([product.productIdentifier isEqualToString:_productIdentifier]) {
     *stop = YES;
     
     [[IAPHelper sharedInstance] buyProduct:product];
     [self performSelector:@selector(showHUDWithMessage:) withObject:@"Purchasing..." afterDelay:0.0];
     }
     }];*/
    
    
}

- (IBAction)restorePurchase:(id)sender{
    [[IAPHelper sharedInstance] restoreCompletedTransactions];
}

#pragma mark - SVProgress HUD
- (void) showHUDWithMessage:(NSString*)message{
    [SVProgressHUD showWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
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

- (IBAction)ActionUnlock:(id)sender {
    [self restorePurchase:sender];
    [self removeAd:sender];
}

- (IBAction)ActionWatchIntro:(id)sender {
    [self watchIntroBtnPressed:sender];
}

- (IBAction)ActionAsk:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"askmechanicVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ActionVinli:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vinliVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
