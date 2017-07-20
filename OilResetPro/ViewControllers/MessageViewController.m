//
//  MessageViewController.m
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
{
    NSMutableArray *selectedMessages;
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;


@end

@implementation MessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self setTitle:@"Message"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.tableView setEstimatedRowHeight:80];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
}
- (void) actionMenu:(id)sender{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) actionShowSearch:(id)sender{
    
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showHUD];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[ORPNetworkManager sharedManager] GET:[NSString stringWithFormat:@"%@?email=%@", getallmessage, [UserModel getUser].user_email] data:nil progress:nil completion:^(id data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self hideHUD];
                NSLog(@"Error: %@", error);
                
            }else{
                if ([data[@"response"] isEqualToString:@"success"]) {
                    [self hideHUD];
                    dataArray = data[@"all_messages"];
                    [self.tableView reloadData];
                }else{
                    [self hideHUD];
                }
            }
        });
    }];
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

    selectedMessages = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"update_Message = %@", selectedMessages);
    appdelegate().messagecount = (int)(dataArray.count - selectedMessages.count);
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setInteger:appdelegate().messagecount forKey:@"messagecount"];
    [[ORPNetworkManager sharedManager] POST:updatemessage data:@{@"messageids": selectedMessages} completion:^(id data, NSError *error) {
        NSLog(@"update_Message = %@", data);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) showHUD{
    [SVProgressHUD show];
}

- (void) hideHUD{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *titleLabel = [cell viewWithTag:1];
    UILabel *messageLabel = [cell viewWithTag:2];
    UILabel *timeLabel = [cell viewWithTag:3];
    NSDictionary *data = [dataArray objectAtIndex:indexPath.row];
    titleLabel.text = data[@"title"];
    messageLabel.text = data[@"message"];
    timeLabel.text = data[@"time"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [dataArray objectAtIndex:indexPath.row];
    [selectedMessages addObject:data[@"id"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}


// From Master/Detail Xcode template
@end
