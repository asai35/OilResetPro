//
//  HomeViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
#import <VinliSDK.h>
#import "ECSlidingViewController.h"

@interface HomeViewController : UIViewController <EAIntroDelegate, ECSlidingViewControllerDelegate>{
    
}
@property (strong, nonatomic) VLService *vlService;

@end
