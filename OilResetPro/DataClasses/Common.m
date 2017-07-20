//
//  Common.m
//  SomthingLocal
//
//  Created by Asai on 1/17/14.
//  Copyright (c) 2014 ResetPro. All rights reserved.
//

#import "Common.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import "UserHelper.h"
@implementation Common

+ (ASIFormDataRequest*)getPostRequestForUrl:(NSString*)srvrURL withParameters:(NSDictionary*)parameters{
    NSURL *url = [NSURL URLWithString:srvrURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    for( NSString *aKey in [parameters allKeys] ){
        if ([aKey isEqualToString:@"image1"] || [aKey isEqualToString:@"store_image"]) {
            [request setData:[parameters objectForKey:aKey] withFileName:@"myphoto.png" andContentType:@"image/png" forKey:aKey];
        }
        else {
            [request setPostValue:[parameters objectForKey:aKey] forKey:aKey];
        }
    }
    
	[request setNumberOfTimesToRetryOnTimeout:2];
    if (![Common connectedToNetwork]) {
        [request setTimeOutSeconds:0];
        [UserHelper showErrorWithMessage:@"Oops." :@"An active network connection is required."];
    }
    else {
        [request setTimeOutSeconds:1000000];
    }
	
	return request;
}

+ (ASIHTTPRequest*) getRequestForParamtersGet :(NSString*)srvrURL withParameters:(NSDictionary*)parameters{
    
    
    NSMutableString *urlSt = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@?",srvrURL]];
    for( NSString *aKey in [parameters allKeys] ){
        [urlSt appendFormat:@"%@", [NSString stringWithFormat:@"%@&",aKey]];
        //,[parameters objectForKey:aKey]
    }
    NSString *str = [urlSt substringToIndex:[urlSt length]-1];
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // Connect
    
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
	[request setNumberOfTimesToRetryOnTimeout:2];
    
    if (![Common connectedToNetwork]) {
        [UserHelper showError:@"Oops." withMessage:@"An active network connection is required."];
        [request setTimeOutSeconds:0];
        
    }
    else {
        [request setTimeOutSeconds:100];
    }
    
    
    return request;
}

+ (ASIFormDataRequest*)getPostRequestForUrl:(NSString*)srvrURL{
    
    NSURL *url = [NSURL URLWithString:srvrURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
	[request setNumberOfTimesToRetryOnTimeout:2];
	
    if (![Common connectedToNetwork]) {
        [request setTimeOutSeconds:0];
        [UserHelper showErrorWithMessage:@"Oops." :@"An active network connection is required."];
    }
    else {
        [request setTimeOutSeconds:1000000];
    }
	
	return request;
}

+ (NSString *)getSynchronousServerOutputFor:(NSString *)srvrURL withParameters:(NSDictionary*)parameters{
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
    
	NSURL *url = [NSURL URLWithString:srvrURL];
    
    // Connect
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    for( NSString *aKey in [parameters allKeys] ){
        if ([aKey isEqualToString:@"image1"]) {
            [request setData:[parameters objectForKey:aKey] withFileName:@"myphoto.png" andContentType:@"image/png" forKey:aKey];
        }
        else {
            [request setPostValue:[parameters objectForKey:aKey] forKey:aKey];
        }
    }
    
	[request setNumberOfTimesToRetryOnTimeout:2];
    
    if (![Common connectedToNetwork]) {
        [UserHelper showErrorWithMessage:@"Error." :@"An active network connection is required to use SomeThingLocal."];
        [request setTimeOutSeconds:0];
    }
    else {
        [request setTimeOutSeconds:3000];
    }
	
	[request startSynchronous];
    
	NSError *error = [request error];
	NSString *response = @"";
	if (!error) {
		response = [request responseString];
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
	
	return response;
}

#pragma mark - System Configration

+ (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
    
}


@end
