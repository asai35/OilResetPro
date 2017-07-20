//
//  ProfileViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
@interface ProfileViewController (){
    NSArray *iconArray;
    NSArray *placeholderArray;
    UITextField *activeField;
    UserModel *user;
    UIImage *userPhoto;
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    iconArray = @[@"ic_username", @"ic_email", @"ic_password", @"ic_phone", @"ic_twitter"];
    placeholderArray = @[@"Name", @"Email", @"Password", @"Phone", @"Connect"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"ic_menu"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionShowSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbar2=[[UIBarButtonItem alloc] init];
    [rightbar2 setCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbar2;
    
    [self setTitle:@"Profile"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    user = [UserModel getUser];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
}
- (void) actionMenu:(id)sender{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) actionShowSearch:(id)sender{
    
}
- (void)tapView:(UITapGestureRecognizer*)recognizer{
    [self.view endEditing:YES];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    [_viewAvatar.layer setCornerRadius:_viewAvatar.frame.size.height / 2];
    _viewAvatar.clipsToBounds = YES;
    [_viewCamera.layer setCornerRadius:_viewCamera.frame.size.height / 2];
    _viewCamera.clipsToBounds = YES;
    [_viewLogout.layer setCornerRadius:_viewLogout.frame.size.height / 2];
    _viewLogout.clipsToBounds = YES;
    [self registNotification];
    [_imvAvatar sd_setImageWithURL:[NSURL URLWithString:user.photo_url] placeholderImage:userPhoto != nil ? userPhoto : [UIImage imageNamed:@"person-avatar"]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self unregistNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    [cell.imgView setImage:[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]]];
    [cell.textField setPlaceholder:[placeholderArray objectAtIndex:indexPath.row]];
    [cell.textField setReturnKeyType:UIReturnKeyDone];
    
    // Configure the cell...
    [cell.textField setDelegate:(id)self];
    if (indexPath.row == 0) {
        cell.textField.text = user.user_name;
    }else if (indexPath.row == 1) {
        cell.textField.text = user.user_email;
        [cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
    }else if (indexPath.row == 2) {
        cell.textField.text = user.user_password;
        cell.textField.secureTextEntry = YES;
        
    }else if (indexPath.row == 3) {
        cell.textField.text = user.phone;
        [cell.textField setKeyboardType:UIKeyboardTypePhonePad];
    }
    [cell.textField setTag:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self.view endEditing:YES];
}
-(void) registNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) unregistNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShown:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height, keyboardSize.width);
    CGPoint point = [activeField convertPoint:activeField.frame.origin toView:self.view];
    if (point.y > (self.view.frame.size.height - height)) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect f = self.profileTable.frame;
            f.origin.y -= point.y - (self.view.frame.size.height - height - 80);
            self.profileTable.frame = f;
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect f = self.profileTable.frame;
        f.origin.y = 64;
        self.profileTable.frame = f;
        [activeField resignFirstResponder];
    }];
}
#pragma mark -
#pragma mark - TextField Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    activeField.delegate = (id)self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUInteger index = textField.tag;
    if (index == 0) {
        user.user_name = textField.text;
    }else if(index == 1){
        user.user_email = textField.text;
    }else if(index == 2){
        user.user_password = textField.text;
    }else if(index == 3){
        user.phone = textField.text;
    }
    activeField = nil;
    
}

- (IBAction)ActionCamera:(id)sender {
    [self showImagePickerAlert];
}

- (IBAction)ActionLogout:(id)sender {
    UserModel *current_User = [UserModel getUser];
    current_User.user_pament_status = @"";
    current_User.user_name = @"";
    current_User.user_surname = @"";
    current_User.auth_token = @"";
    current_User.user_email = @"";
    current_User.user_password = @"";
    current_User.social_type = @"";
    current_User.user_social_id = @"";
    current_User.phone = @"";
    current_User.photo_url = @"";

    [current_User save];

    [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
}
- (void) showHUD{
    [SVProgressHUD show];
}

- (void) hideHUD{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

- (IBAction)ActionUpdateProfile:(id)sender {
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    params[@"name"] = user.user_name;
    params[@"surname"] = user.user_surname;
    params[@"email"] = user.user_email;
    params[@"phone"] = user.phone;
    if (userPhoto != nil) {
        params[@"image"] = UIImageJPEGRepresentation(userPhoto, 0.8);
    }
    [self showHUD];
    [[ORPNetworkManager sharedManager] UpdateProfile:@"update-user-profile" data:params completion:^(id data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *response = data[@"response"] ;
            [self hideHUD];
            if ([response isEqualToString:@"success"] ) {
                user.photo_url = data[@"photo_url"];
                [user save];
                [self showAlertDialog:@"Update Profile" message:response positive:NSLocalizedString(@"Ok", nil) negative:NSLocalizedString(@"Cancel", nil) sender:self];
            }else if([response isEqualToString:@"no change detected"]){
                [self showAlertDialog:@"Error" message:response positive:NSLocalizedString(@"Ok", nil) negative:NSLocalizedString(@"Cancel", nil) sender:self];
            }else{
                    
                [self showAlertDialog:@"Error" message:response positive:NSLocalizedString(@"Ok", nil) negative:NSLocalizedString(@"Cancel", nil) sender:self];
            }
        });
    }];
}
- (void) showAlertDialog : (NSString *)title message:(NSString *) message positive:(NSString *)strPositivie negative:(NSString *) strNegative sender:(id) sender {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if(strPositivie != nil) {
        UIAlertAction * yesButton = [UIAlertAction
                                     actionWithTitle:strPositivie
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         //Handel your yes please button action here
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
        
        [alert addAction:yesButton];
    }
    
    if(strNegative != nil) {
        UIAlertAction * noButton = [UIAlertAction
                                    actionWithTitle:strNegative
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
        
        [alert addAction:noButton];
    }
    
    [sender presentViewController:alert animated:YES completion:nil];
}

- (void)showImagePickerAlert{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = (id)self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:NO completion:nil];
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = (id)self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:NO completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cameraAction];
    [alert addAction: libraryAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    userPhoto = info[UIImagePickerControllerEditedImage];
    self.imvAvatar.image = userPhoto;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
