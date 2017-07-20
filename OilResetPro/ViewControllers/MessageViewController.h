//
//  MessageViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *dataArray;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
