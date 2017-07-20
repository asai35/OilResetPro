//
//  IAPHelper.h
//  ResetPro
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);


//NSString *const IAPProdFailedNotification =  @"IAPHelperProductFailedNotification";
//NSString *const IAPProdPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchasedWithProductIdentifier:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;
+ (IAPHelper *)sharedInstance;
@end
