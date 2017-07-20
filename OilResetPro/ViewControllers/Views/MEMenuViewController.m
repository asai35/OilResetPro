// MEMenuViewController.m
// TransitionFun
//
// Copyright (c) 2013, Michael Enriquez (http://enriquez.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MEMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import <UIImageView+WebCache.h>
@interface MEMenuViewController (){
    UserModel *user;
}
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *menuIcons;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@end

@implementation MEMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // topViewController is the transitions navigation controller at this point.
    // It is initially set as a User Defined Runtime Attributes in storyboards.
    // We keep a reference to this instance so that we can go back to it without losing its state.
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    user = [UserModel getUser];
    _useravatar.layer.cornerRadius = _useravatar.frame.size.height / 2;
    [_useravatar setClipsToBounds:YES];
    [_useravatar sd_setImageWithURL:[NSURL URLWithString:user.photo_url] placeholderImage:[UIImage imageNamed:@"person-avatar"]];
    [_useremail setText:user.user_email];
    [_username setText:[NSString stringWithFormat:@"%@ %@", user.user_name, user.user_surname]];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Properties

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    
    _menuItems = @[@"Home", @"Messages", @"Profile", @"Settings", @"Saved Resets"];
    
    return _menuItems;
}

- (NSArray *)menuIcons {
    if (_menuIcons) return _menuIcons;
    
    _menuIcons = @[@"ic_home", @"ic_msg", @"ic_profile", @"ic_setting", @"ic_bookmark"];
    return _menuIcons;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height * 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *imvicon = [cell viewWithTag:1];
    UILabel *lbltitle = [cell viewWithTag:2];
    UILabel *lblnum = [cell viewWithTag:3];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    NSString *menuIconName = self.menuIcons[indexPath.row];
    
    lbltitle.text = menuItem;
    [imvicon setImage:[UIImage imageNamed:menuIconName]];
    
    if (indexPath.row == 1) {
        int messageCount = appdelegate().messagecount;
        lblnum.text = [NSString stringWithFormat:@"%d", messageCount];
    }else if(indexPath.row == 4){
        int savedResetCount = (int)[[SaveData allObjects] count];
        lblnum.text = [NSString stringWithFormat:@"%d", savedResetCount];
    }else{
        lblnum.hidden = YES;
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    if ([menuItem isEqualToString:@"Home"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNav"];;
    } else if ([menuItem isEqualToString:@"Messages"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"messageNav"];
    } else if ([menuItem isEqualToString:@"Settings"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingNav"];
    } else if ([menuItem isEqualToString:@"Profile"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNav"];
    } else if ([menuItem isEqualToString:@"Saved Resets"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"resetNav"];
    }


    [self.slidingViewController resetTopViewAnimated:YES];
}

@end
