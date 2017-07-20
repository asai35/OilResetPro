//
//  TotalYearsCell.h
//  OilResetPro
//
//  Created by Asai on 3/27/17.
//  Copyright © 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalYearsCell : UITableViewCell{
    IBOutlet UILabel *_yearsLbl;
    IBOutlet UIButton *_backBtn;
}

@property (nonatomic, strong) IBOutlet UILabel *_yearsLbl;
@property (nonatomic, strong) IBOutlet UIButton *_backBtn;
@end
