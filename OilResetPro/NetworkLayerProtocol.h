//
//  NetworkLayerProtocol.h
//  OilResetPro
//
//  Created by Asai on 3/29/17.
//  Copyright © 2017 OilResetPro. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

@protocol NetworkLayerProtocol <NSObject>

- (instancetype) initWithSession : (AFHTTPSessionManager*) session;

@end
