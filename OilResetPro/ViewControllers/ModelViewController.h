//
//  ModelViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "AllFetchData.h"
@import GoogleMobileAds;

#define REVMOB_ID @"52e05b570cf13a1240000003"

@interface ModelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *_modelTableView;
    IBOutlet UILabel *_yearLbl;
    IBOutlet UILabel *_makeLbl;
    
    IBOutlet UISearchDisplayController *searchDisplayController;
    NSMutableArray *_setArray;
    NSMutableArray *_SearchResult;
    
    IBOutlet GADBannerView *bannerView;
    NSMutableArray *getArray;
    IBOutlet UISearchBar *_searchBar;
    
}
@property AllFetchData *_setData;
@property NSString *_selectedYear;
@property NSString *_selectedMake;
@property NSMutableArray *_modelsArray;

- (void)initWithMake:(AllFetchData*)data;
- (void)initWithYear:(NSString*)year Make:(NSString*)sMake ModelArray:(NSMutableArray*)array;
@end
