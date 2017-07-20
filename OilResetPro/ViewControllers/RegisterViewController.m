//
//  RegisterViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "RegisterViewController.h"
#import "IntroPageViewController.h"

const static CGFloat kJVFieldHeight = 36.0f;
const static CGFloat kJVFieldHMargin = 10.0f;
const static CGFloat kJVFieldFontSize = 16.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface RegisterViewController ()
{
    JVFloatLabeledTextField *activeField;
    UIColor *signTextColor;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerbackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    [self setTitle:@"Sign Up"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                         forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIColor *floatingLabelColor = UIColorFromRGB(0xcecece);
    
    signTextColor = UIColorFromRGB(0xefefef);
    
    _txtName = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, self.nameView.frame.size.width, self.nameView.frame.size.height)];
    _txtName.font = AvenirLTStdLight(kJVFieldFontSize);
    _txtName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"NAME", @"")
                                    attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xafafaf), NSFontAttributeName:AvenirLTStdBook(kJVFieldFloatingLabelFontSize)}];
    _txtName.floatingLabelFont = AvenirLTStdBook(kJVFieldFloatingLabelFontSize);
    _txtName.floatingLabelTextColor = floatingLabelColor;
    _txtName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtName.delegate = (id)self;
    _txtName.backgroundColor = [UIColor clearColor];
    [self.nameView addSubview:_txtName];
    _txtName.translatesAutoresizingMaskIntoConstraints = NO;
    _txtName.keepBaseline = YES;
    [_txtName setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtName setReturnKeyType:UIReturnKeyNext];
    [_txtName setBackground:nil];
    [_txtName setBackgroundColor:[UIColor clearColor]];
    [_txtName setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_txtName setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.nameView addSubview:_txtName];
    [self.nameView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(xMargin)-[_txtName]-(xMargin)-|" options:0 metrics:@{@"xMargin": @(kJVFieldHMargin)} views:NSDictionaryOfVariableBindings(_txtName)]];
    [self.nameView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_txtName(>=minHeight)]|" options:0 metrics:@{@"minHeight": @(kJVFieldHeight)} views:NSDictionaryOfVariableBindings(_txtName)]];
    
    
    _txtEmailAddress = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, self.emailView.frame.size.width, self.emailView.frame.size.height)];
    _txtEmailAddress.font = AvenirLTStdLight(kJVFieldFontSize);
    _txtEmailAddress.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"EMAIL", @"")
                                    attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xafafaf), NSFontAttributeName:AvenirLTStdBook(kJVFieldFloatingLabelFontSize)}];
    _txtEmailAddress.floatingLabelFont = AvenirLTStdBook(kJVFieldFloatingLabelFontSize);
    _txtEmailAddress.floatingLabelTextColor = floatingLabelColor;
    _txtEmailAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtEmailAddress.delegate = (id)self;
    _txtEmailAddress.backgroundColor = [UIColor clearColor];
    [self.emailView addSubview:_txtEmailAddress];
    _txtEmailAddress.translatesAutoresizingMaskIntoConstraints = NO;
    _txtEmailAddress.keepBaseline = YES;
    [_txtEmailAddress setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtEmailAddress setReturnKeyType:UIReturnKeyNext];
    [_txtEmailAddress setBackground:nil];
    [_txtEmailAddress setBackgroundColor:[UIColor clearColor]];
    [_txtEmailAddress setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_txtEmailAddress setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.emailView addSubview:_txtEmailAddress];
    [self.emailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(xMargin)-[_txtEmailAddress]-(xMargin)-|" options:0 metrics:@{@"xMargin": @(kJVFieldHMargin)} views:NSDictionaryOfVariableBindings(_txtEmailAddress)]];
    [self.emailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_txtEmailAddress(>=minHeight)]|" options:0 metrics:@{@"minHeight": @(kJVFieldHeight)} views:NSDictionaryOfVariableBindings(_txtEmailAddress)]];
    
    
    _txtPassword = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, self.passView.frame.size.width, self.passView.frame.size.height)];
    _txtPassword.font = AvenirLTStdLight(kJVFieldFontSize);
    _txtPassword.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"PASSWORD", @"")
                                    attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xafafaf), NSFontAttributeName:AvenirLTStdBook(kJVFieldFloatingLabelFontSize)}];
    _txtPassword.floatingLabelFont = AvenirLTStdBook(kJVFieldFloatingLabelFontSize);
    _txtPassword.floatingLabelTextColor = floatingLabelColor;
    _txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtPassword.delegate = (id)self;
    _txtPassword.backgroundColor = [UIColor clearColor];
    [self.passView addSubview:_txtPassword];
    _txtPassword.translatesAutoresizingMaskIntoConstraints = NO;
    _txtPassword.keepBaseline = YES;
    [_txtPassword setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtPassword setReturnKeyType:UIReturnKeyNext];
    [_txtPassword setBackground:nil];
    [_txtPassword setBackgroundColor:[UIColor clearColor]];
    [_txtPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_txtPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_txtPassword setSecureTextEntry:YES];
    [self.passView addSubview:_txtPassword];
    [self.passView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(xMargin)-[_txtPassword]-(xMargin)-|" options:0 metrics:@{@"xMargin": @(kJVFieldHMargin)} views:NSDictionaryOfVariableBindings(_txtPassword)]];
    [self.passView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_txtPassword(>=minHeight)]|" options:0 metrics:@{@"minHeight": @(kJVFieldHeight)} views:NSDictionaryOfVariableBindings(_txtPassword)]];
    
    
    _txtRepeatPassword = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, self.confirmpassView.frame.size.width, self.confirmpassView.frame.size.height)];
    _txtRepeatPassword.font = AvenirLTStdLight(kJVFieldFontSize);
    _txtRepeatPassword.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"REPEAT PASSWORD", @"")
                                    attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xafafaf), NSFontAttributeName:AvenirLTStdBook(kJVFieldFloatingLabelFontSize)}];
    _txtRepeatPassword.floatingLabelFont = AvenirLTStdBook(kJVFieldFloatingLabelFontSize);
    _txtRepeatPassword.floatingLabelTextColor = floatingLabelColor;
    _txtRepeatPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtRepeatPassword.delegate = (id)self;
    _txtRepeatPassword.backgroundColor = [UIColor clearColor];
    [self.confirmpassView addSubview:_txtRepeatPassword];
    _txtRepeatPassword.translatesAutoresizingMaskIntoConstraints = NO;
    _txtRepeatPassword.keepBaseline = YES;
    [_txtRepeatPassword setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtRepeatPassword setReturnKeyType:UIReturnKeyDone];
    [_txtRepeatPassword setBackground:nil];
    [_txtRepeatPassword setSecureTextEntry:YES];
    [_txtRepeatPassword setBackgroundColor:[UIColor clearColor]];
    [_txtRepeatPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_txtRepeatPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.confirmpassView addSubview:_txtRepeatPassword];
    [self.confirmpassView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(xMargin)-[_txtRepeatPassword]-(xMargin)-|" options:0 metrics:@{@"xMargin": @(kJVFieldHMargin)} views:NSDictionaryOfVariableBindings(_txtRepeatPassword)]];
    [self.confirmpassView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_txtRepeatPassword(>=minHeight)]|" options:0 metrics:@{@"minHeight": @(kJVFieldHeight)} views:NSDictionaryOfVariableBindings(_txtRepeatPassword)]];
    
    UITapGestureRecognizer *tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImageView:)];
    [tapProfile setNumberOfTapsRequired:1];
    [_avatarImageView setUserInteractionEnabled:YES];
    [_avatarImageView addGestureRecognizer:tapProfile];
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self registNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self unregistNotification];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ActionRegister:(id)sender {
    
    if (_txtName.text.length == 0) {
        [self showAlertDialog:@"Warning!" message:@"Please enter your lastname" positive:@"Ok" negative:@"Cancel" sender:self];
        return;
    }
    if (_txtEmailAddress.text.length == 0) {
        [self showAlertDialog:@"Warning!" message:@"Please enter your email address" positive:@"Ok" negative:@"Cancel" sender:self];
        return;
    }
    if (![self validEmailAddress]) {
        return;
    }
    if (_txtPassword.text.length == 0) {
        [self showAlertDialog:@"Warning!" message:@"Please enter your password" positive:@"Ok" negative:@"Cancel" sender:self];
        return;
    }
    if (_txtRepeatPassword.text.length == 0) {
        [self showAlertDialog:@"Warning!" message:@"Please enter your confirm password" positive:@"Ok" negative:@"Cancel" sender:self];
        return;
    }
    if (![_txtPassword.text isEqualToString:_txtRepeatPassword.text]) {
        [self showAlertDialog:@"Warning!" message:@"Please enter correct confirm password" positive:@"Ok" negative:@"Cancel" sender:self];
        return;
    }

    [self showHUD];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"name"] = _txtName.text;
    params[@"surname"] = _txtName.text;
    params[@"email"] = _txtEmailAddress.text;
    params[@"password"] = _txtPassword.text;
    params[@"platform"] = @"IOS";
    params[@"push_token"] = appdelegate().push_token;

    [[ORPNetworkManager sharedManager] POST:@"add-new-user" data:params completion:^(id data, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
            int response = (int)[data[@"response"] integerValue];
            if (response > 0) {
                UserModel *current_User = [UserModel getUser];
                current_User.auth_token = data[@"auth_token"];
                current_User.user_name = _txtName.text;
                current_User.user_surname = _txtName.text;
                current_User.user_email = _txtEmailAddress.text;
                current_User.user_password = _txtPassword.text;
                current_User.user_pament_status = @"has_not_paid";
                current_User.user_push_token = appdelegate().push_token;
                [[ORPNetworkManager sharedManager] setAuthToken:data[@"auth_token"]];
    
//                ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"slideVC"];
//                [vc setTopViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeNav"]];
//                [self.navigationController pushViewController:vc animated:YES];
                ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"slideVC"];
                [vc setTopViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"introNav"]];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [self showAlertDialog:@"Error" message:data[@"response"] positive:NSLocalizedString(@"Ok", nil) negative:NSLocalizedString(@"Cancel", nil) sender:self];

            }
        });

    }];
    
}

- (BOOL) validEmailAddress{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:_txtEmailAddress.text] == NO) {
        [self showAlertDialog:@"Warning!" message:@"Please enter valid email" positive:@"Ok" negative:@"Cancel" sender:self];
        return NO;
    }
    return YES;
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

- (void) showHUD{
    [SVProgressHUD show];
}

- (void) hideHUD{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

# pragma mark - Button Action

- (IBAction)registerbackBtnAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ActionGotoSignIn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - TextField Delegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _txtName) {
        [_txtEmailAddress becomeFirstResponder];
    }
    if (textField == _txtEmailAddress) {
        [_txtPassword becomeFirstResponder];
    }
    if (textField == _txtPassword) {
        [_txtRepeatPassword becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
-(void)textFieldDidBeginEditing:(JVFloatLabeledTextField *)textField
{
    activeField = textField;
    activeField.delegate = (id)self;
    _txtName.textColor = signTextColor;
    _txtPassword.textColor = signTextColor;
    _txtRepeatPassword.textColor = signTextColor;
    _txtEmailAddress.textColor = signTextColor;
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    _txtEmailAddress.textColor = signTextColor;
    _txtPassword.textColor = signTextColor;
    _txtName.textColor = signTextColor;
    _txtRepeatPassword.textColor = signTextColor;
    
    [self checkTextField];
    
}

- (void) checkTextField{
    
    if (_txtName.text.length>0 && _txtEmailAddress.text.length>0 && _txtPassword.text.length>0 && _txtRepeatPassword.text.length>0) {
        
        self.btnContinue.layer.shadowColor = UIColorFromRGB(0x4f8ccd).CGColor;
        self.btnContinue.layer.shadowRadius = 9;
        self.btnContinue.layer.shadowOpacity = 0.8;
        self.btnContinue.layer.shadowOffset = CGSizeMake(0, 0);
        self.btnContinue.enabled = YES;
        self.btnContinue.backgroundColor = [UIColor clearColor];
        [self.btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnContinue.layer.shadowColor = [UIColor whiteColor].CGColor;
    }else{
        self.btnContinue.layer.shadowColor = UIColorFromRGB(0x4f8ccd).CGColor;
        self.btnContinue.layer.shadowRadius = 9;
        self.btnContinue.layer.shadowOpacity = 0.8;
        self.btnContinue.layer.shadowOffset = CGSizeMake(0, 0);
        
        self.btnContinue.backgroundColor = [UIColor clearColor];
        [self.btnContinue setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContinue.layer.shadowColor = [UIColor blackColor].CGColor;
        self.btnContinue.enabled = NO;
        
    }
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
    float offsetY = 80;
    if (activeField == _txtPassword) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = -offsetY;//(offsetY + deltaY);
            self.view.frame = f;
        }];
    }
    if (activeField == _txtRepeatPassword) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = - 2 * offsetY;//(offsetY + deltaY);
            self.view.frame = f;
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0;
        self.view.frame = f;
        [activeField resignFirstResponder];
    }];
}


- (void)tapProfileImageView:(UITapGestureRecognizer *)recognizer{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cameraAction];
    [alert addAction: libraryAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
