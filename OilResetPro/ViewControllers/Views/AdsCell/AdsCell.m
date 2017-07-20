//
//  AdsCell.m
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 O16 Labs. All rights reserved.
//

#import "AdsCell.h"

@interface AdsCell ()


@end

@implementation AdsCell

+ (AdsCell*) loadCell:(id)controller{
    NSString *nibName = @"AdsCell";
    AdsCell *cell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:controller options:0] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

@end
