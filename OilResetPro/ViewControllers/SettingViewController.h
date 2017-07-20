//
//  SettingViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "IAPHelper.h"

@interface SettingViewController : UIViewController{
    NSArray *_products;
    
    IBOutlet UIButton *btnWatchIntro;
    IBOutlet UIButton *_btnRemoveAds;
}

@property (nonatomic, strong) NSString* _productIdentifier;
@property (nonatomic, strong) NSString* _purchasedIdentifier;
- (IBAction)ActionUnlock:(id)sender;
- (IBAction)ActionWatchIntro:(id)sender;
- (IBAction)ActionAsk:(id)sender;
- (IBAction)ActionVinli:(id)sender;
@end
