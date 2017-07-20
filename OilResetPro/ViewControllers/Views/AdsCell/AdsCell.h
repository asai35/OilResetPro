//
//  AdsCell.h
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 O16 Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GADBannerView.h>

@interface AdsCell : UITableViewCell{

}

+ (AdsCell*) loadCell:(id)controller;

@property (nonatomic,assign)   IBOutlet GADBannerView *bannerView;

@end
