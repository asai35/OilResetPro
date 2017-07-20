//
//  AllFetchData.h
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SQPersist/SQPObject.h>

@interface AllFetchData : SQPObject{

}

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *make;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *reset;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, strong) NSString *searchString;

+(void)loadDataFromJson:(NSArray*)jsonString withCompletionBlock:(void (^)(NSMutableArray *cars))completionBlock;

-(id) initWithDictionary:(NSDictionary*)dictionary;

+(NSMutableArray*) loadDataFromJsonForLockedCars:(NSArray*)jsonString;
-(id) initWithDictionaryLockedCars:(NSDictionary*)dictionary;

@end
