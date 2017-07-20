//
//  ResetProcedureViewController.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2017 OilResetPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import "AllFetchData.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ResetProcedureViewController : UIViewController<UITextViewDelegate,RevMobAdsDelegate,MFMailComposeViewControllerDelegate>{
    
    BOOL *_isFirst;
    
    IBOutlet UIView *_baseView;
    IBOutlet UIView *_multiFuncVuew;
    IBOutlet UIView *_naviView;
    
    IBOutlet UIButton *_first;
    IBOutlet UIButton *_second;
    IBOutlet UIButton *_third;
    
    IBOutlet UITextView *_baseTextView;
    IBOutlet UITextView *_funcTextView;
    IBOutlet UITextView *_naviTextView;
    NSString *setResetData;
    
    NSMutableArray *resetArray;
    NSMutableArray *array;
    
    IBOutlet UIButton *btnSelect;
    NSString *carDetail;
    NSString *video;
}

//@property (nonatomic, strong)RevMobBanner *bannerWindow;

@property(nonatomic,assign)BOOL addRecieved;
@property (nonatomic, strong) AllFetchData *detail;
@property (nonatomic, strong) NSString *selectedYear;
@property (nonatomic, strong) NSString *selectedMake;
@property (nonatomic, strong) NSString *selectedModel;


@end
