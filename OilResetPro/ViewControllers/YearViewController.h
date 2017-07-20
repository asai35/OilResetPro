//
//  YearViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllFetchData.h"

@interface YearViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    AllFetchData *abc;
    IBOutlet UITableView *_yearsTable;
    NSArray *savedArray;
    
    NSArray *tablViewArray;
    NSMutableArray *array;
    NSMutableArray *_SearchResult;
    IBOutlet UISearchBar *_searchBar;
    
    NSString *text;

}

@end
