//
//  VinliDetailViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VinliDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tblDetailVinli;
@property NSMutableArray *deviceDataArray;
@property NSString *deviceId;
@end
