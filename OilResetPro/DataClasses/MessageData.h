//
//  MessageData.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import <Realm/Realm.h>

@interface MessageData : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *time;

@end
