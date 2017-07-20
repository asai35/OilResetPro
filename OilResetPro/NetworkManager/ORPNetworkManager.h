//
//  ORPNetworkManager.h
//  OilResetPro
//
//  Created by Asai on 3/29/17.
//  Copyright © 2017 OilResetPro. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString* const API_BaseURL = @"http://api.devfj.com/";
//static NSString* const API_BaseURL = @"http://oilresetproapi.sandboxserver.co.za/";

@interface ORPNetworkManager : NSObject

typedef void(^ResponseHandler)(id data, NSError* error);
typedef void(^ProgressHandler)(float downloaded, float allBytes);

+ (instancetype) sharedManager;

- (void) setAuthToken: (NSString*) token;
- (void) logout;

- (void) PATCH:(NSString*)path
          data:(NSDictionary*)data
    completion:(ResponseHandler) completion;

- (void) UpdateProfile:(NSString*)path
          data:(NSDictionary*)data
    completion:(ResponseHandler) completion;

- (void) POST:(NSString*)path
         data:(NSDictionary*)data
   completion:(ResponseHandler) completion;

- (void) POST:(NSString*)path
         data:(NSDictionary*)data
     progress:(ProgressHandler) progressComplition
   completion:(ResponseHandler) completion;

- (void) GET:(NSString*)path
        data:(NSDictionary*)data
  completion:(ResponseHandler) completion;


- (void) GET:(NSString*)path
        data:(NSDictionary*)data
    progress:(ProgressHandler) progressComplition
  completion:(ResponseHandler) completion;

- (void) DELETE:(NSString*)path
           data:(NSDictionary*)data
     completion:(ResponseHandler) completion;

- (void) DELETE:(NSString*)path
           data:(NSDictionary*)data
       progress:(ProgressHandler) progressComplition
     completion:(ResponseHandler) completion;

- (void) PATH:(NSString*)method data:(NSDictionary*)data handler:(ResponseHandler) handler;

- (void) GETAllProcedure:(NSString*)path
                    data:(NSDictionary*)data
                progress:(ProgressHandler) progressComplition
              completion:(ResponseHandler) completion;
- (void) GETAllMessage:(NSString*)path
                    data:(NSDictionary*)data
                progress:(ProgressHandler) progressComplition
              completion:(ResponseHandler) completion;
- (void) GETVinliData:(NSString*)path
                 data:(NSDictionary*)data
             progress:(ProgressHandler) progressComplition
           completion:(ResponseHandler) completion;



@end
