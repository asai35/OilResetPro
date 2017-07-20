//
//  SearchResultCell.m
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 O16 Labs. All rights reserved.
//
#import "SearchResultCell.h"

@interface SearchResultCell ()

@end

@implementation SearchResultCell
@synthesize _backBtn, _yearsLbl, _makeLbl, _modelLbl, _searchStringLbl;

+ (SearchResultCell*) loadCell:(id)controller{
    NSString *nibName = @"SearchResultCell";
    SearchResultCell *cell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:controller options:0] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

@end
