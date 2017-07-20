//
//  AllFetchData.m
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import "AllFetchData.h"
#import "SBJson5.h"
#import "SBJson5Writer.h"
#import "AllFetchData.h"

@implementation AllFetchData
//@synthesize make, model, reset, year, isLocked, searchString;

+(void) loadDataFromJson:(NSArray*)jsonString withCompletionBlock:(void (^)(NSMutableArray *cars))completionBlock{
    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    [array addObjectsFromArray:jsonString];
    
    NSMutableArray *returnAray = [[NSMutableArray alloc] init];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSDictionary *dictionary in jsonString) {
                NSString *make = [dictionary objectForKey:@"make"];
                NSString *model = [dictionary objectForKey:@"model"];
                NSString *year = [dictionary objectForKey:@"year"];
                
                if ([make isKindOfClass:[NSNull class]] ||
                    [model isKindOfClass:[NSNull class]] ||
                    [year isKindOfClass:[NSNull class]]) {
                    
                    continue;
                }
                
                NSString *identifier = [NSString stringWithFormat:@"%@-%@-%@",year,model,make];
                NSString *whereClause = [NSString stringWithFormat:@"identifier = '%@'",identifier];
                AllFetchData *member = [AllFetchData SQPFetchOneWhere:whereClause];
        
                if (!member) {
                    member = [AllFetchData SQPCreateEntity];
                }
                
                [member updateDataWithJson:dictionary];
                member.identifier = identifier;
                
                [member SQPSaveEntity];
                
                //AllFetchData *data = [[AllFetchData alloc] initWithDictionary:dictionary];
                
                [returnAray addObject:member];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(returnAray);
                }
                
            });
        });
        
    }];
}

-(id) initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    
    [self updateDataWithJson:dictionary];
    
    return self;
}

- (void) updateDataWithJson:(NSDictionary*)dictionary{
    
    self.year = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"year"] intValue]];
    self.make = [dictionary objectForKey:@"make"];
    //self._model = [dictionary objectForKey:@"model"];
    id model = [dictionary objectForKey:@"model"];
    _video = [dictionary objectForKey:@"video"];
    if ([model isKindOfClass:[NSString class]]) {
        self.model = (NSString*)model;
    }
    else if ([model isKindOfClass:[NSNumber class]]){
        self.model = [NSString stringWithFormat:@"%zd",[model integerValue]];
    }
    else {
        NSLog(@"pata nahin %@ %@ %@",self.make,self.year,[model class]);
    }
    
    self.reset = [dictionary objectForKey:@"reset"];
    
    self.searchString = [NSString stringWithFormat:@"%@ %@ %@ ",self.year,self.model,self.make];
}

- (NSString*)description{
    return [NSString stringWithFormat:@"%@ %@ %@ %@",
            self.year,
            self.make,
            self.model,
            self.searchString
            ];
}

+(NSMutableArray*) loadDataFromJsonForLockedCars:(NSArray*)jsonString{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:jsonString];
    
    NSMutableArray *returnAray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        
        AllFetchData *data = [[AllFetchData alloc] initWithDictionaryLockedCars:dictionary];
        
        [returnAray addObject:data];
    }
    
    return returnAray;
}

-(id) initWithDictionaryLockedCars:(NSDictionary*)dictionary{
    self = [super init];
    
    self.year = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"year"] intValue]];
    self.make = [dictionary objectForKey:@"make"];
    //self._model = [dictionary objectForKey:@"model"];
    id model = [dictionary objectForKey:@"model"];
    if ([model isKindOfClass:[NSString class]]) {
        self.model = (NSString*)model;
    }
    else if ([model isKindOfClass:[NSNumber class]]){
        self.model = [NSString stringWithFormat:@"%ld",(long)[model integerValue]];
    }
    else {
        NSLog(@"pata nahin %@ %@ %@",_make,_year,[model class]);
    }
    self.reset = [dictionary objectForKey:@"reset"];
    self.isLocked = NO;
    
    self.searchString = [NSString stringWithFormat:@"%@ %@ %@ ",self.year,self.model, self.make];
    return self;
}

#pragma mark - Override
- (BOOL)isEqual:(id)object{
    AllFetchData *member = (AllFetchData*)object;
    
    NSString *key1 = @"";
    NSString *key2 = @"";

    key1 = [NSString stringWithFormat:@"%@%@%@",self.year,self.make,self.model];
    key2 = [NSString stringWithFormat:@"%@%@%@",member.year,member.make,self.model];
    
    if (member == self)
        return YES;
    if (!member || ![member isKindOfClass:[self class]])
        return NO;
    if ([key1 isEqualToString:key2])
        return YES;
    return NO;
}

- (NSUInteger)hash{
    return [[NSString stringWithFormat:@"%@%@%@",self.year,self.make,self.model] integerValue];
}
@end
