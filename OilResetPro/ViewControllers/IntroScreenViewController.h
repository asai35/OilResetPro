//
//  IntroViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroScreenViewController : UIViewController<EAIntroDelegate>
@property  NSUInteger pageIndex;
@property  NSString *imgFile;
@property  NSString *txtTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivScreenImage;
//@property (weak, nonatomic) IBOutlet UILabel *lblScreenLabel;

@end
