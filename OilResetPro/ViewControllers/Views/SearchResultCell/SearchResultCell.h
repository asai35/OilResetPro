//
//  SearchResultCell.h
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 O16 Labs. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell{
    IBOutlet UILabel *_yearsLbl;
    IBOutlet UILabel *_makeLbl;
    IBOutlet UILabel *_modelLbl;
    IBOutlet UIButton *_backBtn;
    
    IBOutlet UILabel *_searchStringLbl;
    
}

+ (SearchResultCell*) loadCell:(id)controller;
@property (nonatomic, strong) IBOutlet UILabel *_yearsLbl;
@property (nonatomic, strong) IBOutlet UILabel *_makeLbl;
@property (nonatomic, strong) IBOutlet UILabel *_modelLbl;
@property (nonatomic, strong) IBOutlet UIButton *_backBtn;

@property (nonatomic, strong) IBOutlet UILabel *_searchStringLbl;
@end
