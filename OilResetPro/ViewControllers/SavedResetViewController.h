//
//  SavedResetViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedResetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    RLMResults *dataArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
