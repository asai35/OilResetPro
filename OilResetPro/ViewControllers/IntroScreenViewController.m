//
//  IntroViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 ResetPro. All rights reserved.
//

#import "IntroScreenViewController.h"

@interface IntroScreenViewController ()

@end

@implementation IntroScreenViewController

@synthesize ivScreenImage;
@synthesize pageIndex,imgFile,txtTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ivScreenImage.image = [UIImage imageNamed:self.imgFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
