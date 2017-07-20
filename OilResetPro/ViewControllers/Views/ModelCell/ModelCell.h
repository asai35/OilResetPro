//
//  TotalYearsCell.h
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 O16 Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelCell : UITableViewCell{
    IBOutlet UILabel *_modelLbl;
    IBOutlet UIButton *_backBtn;
}

@property (nonatomic, strong) IBOutlet UILabel *_modelLbl;
@property (nonatomic, strong) IBOutlet UIButton *_backBtn;
@end
