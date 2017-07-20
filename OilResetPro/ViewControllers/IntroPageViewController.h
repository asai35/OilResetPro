//
//  IntroPageViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroScreenViewController.h"
@interface IntroPageViewController : UIViewController<ECSlidingViewControllerDelegate>
@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (nonatomic,strong) NSArray *arrPageTitles;
@property (nonatomic,strong) NSArray *arrPageImages;
- (IntroScreenViewController *)viewControllerAtIndex:(NSUInteger)index;

- (IBAction)btnStartAgain:(id)sender;

@end
