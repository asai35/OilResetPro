//
//  AuthViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface AuthViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIView *passView;
@property (strong, nonatomic) IBOutlet UIButton *btnSignin;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
- (IBAction)ActionSignin:(id)sender;
- (IBAction)ActionSignup:(id)sender;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *txtEmail;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *txtPassword;

@end
