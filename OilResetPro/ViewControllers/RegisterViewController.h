//
//  RegisterViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *txtName;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *txtEmailAddress;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *txtPassword;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *txtRepeatPassword;
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIView *passView;
@property (strong, nonatomic) IBOutlet UIView *confirmpassView;
@property (strong, nonatomic) IBOutlet UIButton *btnContinue;
@property (strong, nonatomic) IBOutlet UIButton *btnSignin;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@end
