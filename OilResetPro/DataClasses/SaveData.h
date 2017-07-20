//
//  SaveData.h
//  OilResetPro
//
//  Created by Asai on 3/30/17.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import <Realm/Realm.h>

@interface SaveData : RLMObject
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *make;
@end
