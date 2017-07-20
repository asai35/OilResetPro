//
//  MakeViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#define REVMOB_ID @"52e05b570cf13a1240000003"

@interface MakeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate>{
    
    IBOutlet UISearchDisplayController *searchdDisplayController;
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_lblPassingYear;
    NSArray *tableArray2;
    AllFetchData *setData;
    NSMutableArray *setArray;
    NSMutableArray *_SearchResult;
    IBOutlet UISearchBar *_searchBar;
}
@property NSString *getYear;
@property NSMutableArray *_makesArray;

- (id) initWithItemId:(AllFetchData*)item;
- (id) initWithYear:(NSString*)year Array:(NSMutableArray*)array;
@end
