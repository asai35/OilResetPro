//
//  ProfileViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewLogout;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (strong, nonatomic) IBOutlet UIView *viewCamera;
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) IBOutlet UIView *viewAvatar;
@property (strong, nonatomic) IBOutlet UIImageView *imvAvatar;
@property (strong, nonatomic) IBOutlet UITableView *profileTable;
- (IBAction)ActionCamera:(id)sender;
- (IBAction)ActionLogout:(id)sender;
- (IBAction)ActionUpdateProfile:(id)sender;

@end
