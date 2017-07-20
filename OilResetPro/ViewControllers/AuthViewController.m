//
//  AuthViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//
//

#import "AuthViewController.h"
#import "ECSlidingViewController.h"
const static CGFloat kJVFieldHeight = 36.0f;
const static CGFloat kJVFieldHMargin = 10.0f;
const static CGFloat kJVFieldFontSize = 16.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface AuthViewController ()<UITextFieldDelegate>
{
    JVFloatLabeledTextField *activeField;
    UIColor *signTextColor;
}
@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *floatingLabelColor = UIColorFromRGB(0xcecece);
    
    signTextColor = UIColorFromRGB(0xefefef);
    
    _txtEmail = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, self.emailView.frame.size.width, self.emailView.frame.size.height)];
    _txtEmail.font = AvenirLTStdLight(kJVFieldFontSize);
    _txtEmail.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"EMAIL", @"")
                                    attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xafafaf), NSFontAttributeName:AvenirLTStdBook(kJVFieldFloatingLabelFontSize)}];
    _txtEmail.floatingLabelFont = AvenirLTStdBook(kJVFieldFloatingLabelFontSize);
    _txtEmail.floatingLabelTextColor = floatingLabelColor;
    _txtEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtEmail.delegate = (id)self;
    _txtEmail.backgroundColor = [UIColor clearColor];
    [self.emailView addSubview:_txtEmail];
    _txtEmail.translatesAutoresizingMaskIntoConstraints = NO;
    _txtEmail.keepBaseline = YES;
    [_txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtEmail setReturnKeyType:UIReturnKeyNext];
    [_txtEmail setBackground:nil];
    [_txtEmail setBackgroundColor:[UIColor clearColor]];
    [_txtEmail setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_txtEmail setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.emailView addSubview:_txtEmail];
    [self.emailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(xMargin)-[_txtEmail]-(xMargin)-|" options:0 metrics:@{@"xMargin": @(kJVFieldHMargin)} views:NSDictionaryOfVariableBindings(_txtEmail)]];
    [self.emailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_txtEmail(>=minHeight)]|" options:0 metrics:@{@"minHeight": @(kJVFieldHeight)} views:NSDictionaryOfVariableBindings(_txtEmail)]];
    
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
    [_txtPassword setKeyboardType:UIKeyboardTypeDefault];
    [_txtPassword setReturnKeyType:UIReturnKeyDone];
    [_txtPassword setSecureTextEntry:YES];
    [_txtPassword setBackground:nil];
    [_txtPassword setBackgroundColor:[UIColor clearColor]];
    [_txtPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_txtPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.passView addSubview:_txtPassword];
    [self.passView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(xMargin)-[_txtPassword]-(xMargin)-|" options:0 metrics:@{@"xMargin": @(kJVFieldHMargin)} views:NSDictionaryOfVariableBindings(_txtPassword)]];
    [self.passView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_txtPassword(>=minHeight)]|" options:0 metrics:@{@"minHeight": @(kJVFieldHeight)} views:NSDictionaryOfVariableBindings(_txtPassword)]];
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    [self registNotification];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self unregistNotification];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ActionLoginWithEmail:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"slideVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ActionLoginWithGoogle:(id)sender {
    [self showHUD];
//    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].clientID = kClientID;
    [GIDSignIn sharedInstance].delegate = (id)self;
    [GIDSignIn sharedInstance].uiDelegate =(id) self;
    [[GIDSignIn sharedInstance] signIn];
}
- (IBAction)ActionLoginWithFB:(id)sender {
    
    [appdelegate() loginToFacebook:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Process error");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
                [self showAlertDialog:@"Error" message:NSLocalizedString(@"ERROR_FACEBOOK_LOGIN", nil) positive:NSLocalizedString(@"Ok", nil) negative:NSLocalizedString(@"Cancel", nil) sender:self];
            });
        } else if (result.isCancelled) {
            NSLog(@"isCancelled");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
            });
        } else {
            NSLog(@"Logged in with FB.");
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de setObject:[FBSDKAccessToken currentAccessToken].tokenString forKey:@"accessToken"];
            [self getMyFacebookInfo];
        }

    }];
}

- (void) getMyFacebookInfo {
    [self showHUD];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,first_name,last_name,email,gender,picture"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSString *firstName = [result valueForKey:@"first_name"];
            NSString *lastName = [result valueForKey:@"last_name"];
            NSString *email = [result valueForKey:@"email"];
            NSString *FB_id = [result valueForKey:@"id"];
            
            UserModel *user = [[UserModel alloc] init];
            user.user_name = firstName;
            user.user_surname = lastName;
            user.user_email = email;
            user.user_password = @"";
            user.social_type = @"FACEBOOK";
            user.user_social_id = FB_id;
            [user save];
            
            NSMutableDictionary *registrationData = [[NSMutableDictionary alloc] init];
            if (firstName) registrationData[@"name"] = firstName;
            if (lastName) registrationData[@"surname"] = lastName;
            if (email) registrationData[@"email"] = email;
            if (FB_id) registrationData[@"social_token"] = FB_id;
            registrationData[@"social_type"] = @"FACEBOOK";
            registrationData[@"platform"] = @"IOS";
//            registrationData[@"push_token"] = [[FIRInstanceID instanceID] token];
            registrationData[@"push_token"] = appdelegate().push_token;
            NSLog(@"registrationData = %@", registrationData);
            
            [self login:[NSString stringWithFormat:@"authenticate-user?email=%@&push_token=%@&social_login=%@&platform=%@&social_type=%@", registrationData[@"email"],  registrationData[@"push_token" ], @"gb_gp", @"IOS", registrationData[@"social_type"]]];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
                [self showAlertDialog:@"Error" message:NSLocalizedString(@"ERROR_FACEBOOK_LOGIN", nil) positive:NSLocalizedString(@"Ok", nil) negative:NSLocalizedString(@"Cancel", nil) sender:self];
            });
        }
    }];
}
-(void)Register:(id)params {
    [[ORPNetworkManager sharedManager] POST:@"add-new-user" data:params completion:^(id data, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            int response = (int)[data[@"response"] integerValue];
            if (response  > 0) {
                [self hideHUD];
                UserModel *current_User = [UserModel getUser];
                current_User.auth_token = data[@"auth_token"];
                current_User.user_pament_status = @"has_not_paid";
                current_User.user_push_token = appdelegate().push_token;
                current_User.user_password = @"";
                [current_User save];
                [[ORPNetworkManager sharedManager] setAuthToken:data[@"auth_token"]];
                ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"slideVC"];
                [vc setTopViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"introNav"]];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [self login:[NSString stringWithFormat:@"authenticate-user?email=%@&push_token=%@&social_login=%@&platform=%@&social_type=%@", params[@"email"],  params[@"push_token" ], @"gb_gp", @"IOS", params[@"social_type"]]];
            }
        });
        
    }];
}

- (void) login: (NSString*)parameters{
    
    [[ORPNetworkManager sharedManager] GET:parameters data:nil completion:^(id data, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
            NSString *response = data[@"response"];
            if ([response isEqualToString:@"success"]) {
                UserModel *current_User = [UserModel getUser];
                current_User.user_name = data[@"first_name"];
                current_User.user_surname = data[@"last_name"];
                current_User.user_email = data[@"user_email"];
                current_User.social_type = @"FACEBOOK";
                current_User.user_pament_status = data[@"payment_status"];
                current_User.auth_token = data[@"auth_token"];
                current_User.user_password = @"";
                current_User.phone = data[@"phone"];
                current_User.photo_url = data[@"photo_url"];
                [current_User save];
                [[ORPNetworkManager sharedManager] setAuthToken:data[@"auth_token"]];
                ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"slideVC"];
                [vc setTopViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeNav"]];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
//                [self Register:registrationData];

                [self showAlertDialog:@"Error" message:response positive:NSLocalizedString(@"Ok", nil) negative:NSLocalizedString(@"Cancel", nil) sender:self];
                
            }
        });
    }];

}
- (void) showHUD{
    [SVProgressHUD show];
}

- (void) hideHUD{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
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
// [START headless_google_auth]
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error == nil) {
        UserModel *curUser = [UserModel getUser];
        curUser.user_name = user.profile.givenName;
        curUser.user_surname = user.profile.familyName;
        curUser.user_email  = user.profile.email;
        curUser.user_password  = @"";
        curUser.social_type = @"GOOGLE";
        curUser.user_social_id = user.userID;
        [curUser save];
//        GIDAuthentication *authentication = user.authentication;
        
        NSMutableDictionary *registrationData = [[NSMutableDictionary alloc] init];
        registrationData[@"name"] = curUser.user_name;
        registrationData[@"surname"] = curUser.user_surname;
        registrationData[@"email"] = curUser.user_email;
        registrationData[@"social_token"] = curUser.user_social_id;
        registrationData[@"social_type"] = curUser.social_type;
        registrationData[@"platform"] = @"IOS";
//        registrationData[@"push_token"] = [[FIRInstanceID instanceID] token];
        registrationData[@"push_token"] = appdelegate().push_token;
        NSLog(@"registrationData = %@", registrationData);
        
        [self Register:registrationData];

    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
        });
        [self showAlertDialog:@"Error" message:[NSString stringWithFormat:@"%@", error] positive:NSLocalizedString(@"Ok", nil) negative:NSLocalizedString(@"Cancel", nil) sender:self];
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    if (error) {
        NSLog(@"error occured");
    }
}

- (IBAction)ActionSignin:(id)sender {
    if (![self validEmailAddress]) {
        return;
    }
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [self showHUD:@""];
    [[ORPNetworkManager sharedManager] GET:[NSString stringWithFormat:@"authenticate-user?email=%@&password=%@&platform=IOS&push_token=%@", _txtEmail.text, _txtPassword.text, appdelegate().push_token] data:nil completion:^(id data, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
            NSString *response = data[@"response"];
            if ([response isEqualToString:@"success"]) {
                UserModel *current_User = [UserModel getUser];
                current_User.user_pament_status = data[@"payment_status"];
                current_User.user_name = data[@"first_name"];
                current_User.user_email = _txtEmail.text;
                current_User.user_password = _txtPassword.text;
                current_User.user_surname = data[@"last_name"];
                current_User.auth_token = data[@"auth_token"];
                [current_User save];
                [[ORPNetworkManager sharedManager] setAuthToken:data[@"auth_token"]];
                [self.navigationController.navigationBar setHidden:YES];
                ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"slideVC"];
                [vc setTopViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeNav"]];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self showAlertDialog:@"Error" message:response positive:NSLocalizedString(@"Ok", nil) negative:NSLocalizedString(@"Cancel", nil) sender:self];
                
            }
        });
    }];
    
}

- (IBAction)ActionSignup:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL) validEmailAddress{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:_txtEmail.text] == NO) {
        [self showAlertDialog:@"Warning!" message:@"Please enter valid email" positive:@"Ok" negative:@"Cancel" sender:self];
        return NO;
    }
    return YES;
}

- (void) showHUD:(NSString*)message{
    [SVProgressHUD show];
}

#pragma mark -
#pragma mark - TextField Delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == self.txtEmail) {
        
        [self.txtPassword becomeFirstResponder];
        
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
    _txtEmail.textColor = signTextColor;
    _txtPassword.textColor = signTextColor;
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    _txtEmail.textColor = signTextColor;
    _txtPassword.textColor = signTextColor;
    
    [self checkTextField];
    
}

- (void) checkTextField{
    
    if (_txtEmail.text.length>0 && _txtPassword.text.length>0) {
        
        self.btnSignin.layer.shadowColor = UIColorFromRGB(0x4f8ccd).CGColor;
        self.btnSignin.layer.shadowRadius = 9;
        self.btnSignin.layer.shadowOpacity = 0.8;
        self.btnSignin.layer.shadowOffset = CGSizeMake(0, 0);
        self.btnSignin.enabled = YES;
    }else{
        self.btnSignin.layer.shadowColor = UIColorFromRGB(0x4f8ccd).CGColor;
        self.btnSignin.layer.shadowRadius = 9;
        self.btnSignin.layer.shadowOpacity = 0.8;
        self.btnSignin.layer.shadowOffset = CGSizeMake(0, 0);
        
        self.btnSignin.backgroundColor = [UIColor clearColor];
        [self.btnSignin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnSignin.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.btnSignin.enabled = NO;
        
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
    float offsetY = 100;
    if (activeField == _txtPassword) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect f = self.view.frame;
            f.origin.y -= offsetY;//(offsetY + deltaY);
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
@end
