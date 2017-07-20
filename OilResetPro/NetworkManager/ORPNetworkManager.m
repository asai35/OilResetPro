
//  ORPNetworkManager.m
//  OilResetPro
//
//  Created by Asai on 3/29/17.
//  Copyright © 2017 OilResetPro. All rights reserved.
//

#import "ORPNetworkManager.h"

#import "AFNetworking.h"

typedef void(^URLCallback)(NSURLSessionDataTask* task, NSData* responseData, NSURLResponse* response, NSError* error);

@interface ORPNetworkManager()<NSURLSessionTaskDelegate>

@property (nonatomic,strong) NSMutableDictionary* progressStorage;
@property (nonatomic,strong) NSMutableDictionary* completionStorage;

@property (nonatomic,copy) URLCallback urlCallback;

@end


@implementation ORPNetworkManager{
    NSURLSession* m_session;
    NSString* auth_token;
    NSOperationQueue* m_operationQueue;
    
}

+ (instancetype) sharedManager{
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void) logout{
    auth_token = nil;
}

- (void) setAuthToken:(NSString *)token{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:token forKey:@"auth_token"];
    auth_token = token;
}

- (instancetype) init {
    if (self = [super init]) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        m_session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                  delegate:self
                                             delegateQueue:m_operationQueue];
        
//        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
//        if ([de objectForKey:@"auth_token"]) {
//            auth_token = [de objectForKey:@"auth_token"];
//        }

        
        
        _progressStorage = [NSMutableDictionary new];
        _completionStorage = [NSMutableDictionary new];
        
        __weak ORPNetworkManager* weakSelf = self;
        
        _urlCallback = ^(NSURLSessionDataTask* task, NSData* responseData, NSURLResponse* response, NSError* error){
            
            ResponseHandler completion = weakSelf.completionStorage[@(task.taskIdentifier)];
            
            if (completion) {
                
                if (error) {
                    completion(nil, error);
                    return;
                }
                NSHTTPURLResponse* responseHTTP = (NSHTTPURLResponse*)response;
                
                NSError* serialize_error;
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&serialize_error];
//                NSString *str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                if (serialize_error) {
                    completion(json, serialize_error);
                }
                if (responseHTTP.statusCode == 400) {
                    completion(json, [NSError errorWithDomain:@"Network" code:0 userInfo:@{}]);
                }
                if (weakSelf.progressStorage[@(task.taskIdentifier)]) {
                    [weakSelf.progressStorage removeObjectForKey:@(task.taskIdentifier)];
                }
                completion(json,nil);
                [weakSelf.completionStorage removeObjectForKey:@(task.taskIdentifier)];
            }
        };
    }
    return self;
}

#pragma mark Network methods

- (void) PATCH:(NSString*)path
          data:(NSDictionary*)data
    completion:(ResponseHandler) completion{
    __block NSURLSessionDataTask* task = [m_session dataTaskWithRequest:[self generateRequestWithFormData:@"PATCH"
                                                                                                     path:path
                                                                                                     data:data]
                                                      completionHandler:^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                                          self.urlCallback(task, responseData, response, error);
                                                      }];
    [task resume];
    
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
}

- (void) UpdateProfile:(NSString*)path
                  data:(NSDictionary*)data
            completion:(ResponseHandler) completion{
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@", API_BaseURL, path] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString *key in [data allKeys]) {
            NSObject *obj = data[key];
            if ([obj isKindOfClass:[NSData class]]) {
                [formData appendPartWithFileData:(NSData*)obj name:key fileName:@"profile.png" mimeType:@"image/jpeg"];
            } else if ([obj isKindOfClass:[NSString class]]) {
                NSString *strValue = (NSString *) obj;
                [formData appendPartWithFormData:[strValue dataUsingEncoding:NSUTF8StringEncoding] name:key];
            }
        }
    } error:nil];
    __block NSURLSessionDataTask* task = [m_session dataTaskWithRequest:[self generateRequestWithFormData:@"POST"
                                                                                                     path:path
                                                                                                     data:data]
                                                      completionHandler:^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                                          self.urlCallback(task, responseData, response, error);
                                                      }];
    [task resume];
    
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
}

- (void) POST:(NSString*)path
         data:(NSDictionary*)data
   completion:(ResponseHandler) completion{
   
    [self POST:path data:data progress:nil completion:completion];
}

- (void) POST:(NSString*)path
         data:(NSDictionary*)data
     progress:(ProgressHandler) progressComplition
   completion:(ResponseHandler) completion{
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@", API_BaseURL, path] parameters:data error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (auth_token && [auth_token isEqualToString:@""]){
        NSString* tokenRepresentation = [NSString stringWithFormat:@"%@", auth_token];
        [request setValue:tokenRepresentation forHTTPHeaderField:@"Authorization"];
    }
   
    __block NSURLSessionDataTask* task = [m_session dataTaskWithRequest:request
                                                      completionHandler:^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                                          self.urlCallback(task, responseData, response, error);
                                                      }];
    [task resume];
    if (progressComplition) {
        self.progressStorage[@(task.taskIdentifier)] = progressComplition;
    }
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
    
}



- (void) GET:(NSString*)path
        data:(NSDictionary*)data
  completion:(ResponseHandler) completion{
    [self GET:path data:data progress:nil completion:completion];
}

- (void) GET:(NSString*)path
        data:(NSDictionary*)data
    progress:(ProgressHandler) progressComplition
  completion:(ResponseHandler) completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_BaseURL, path]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    __block NSURLSessionDataTask* task = [m_session dataTaskWithRequest:request
                                                      completionHandler:
                                          ^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                              self.urlCallback(task, responseData, response, error);
                                          }];
    [task resume];
    if (progressComplition) {
        self.progressStorage[@(task.taskIdentifier)] = progressComplition;
    }
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
}

- (void) GETAllProcedure:(NSString*)path
                    data:(NSDictionary*)data
                progress:(ProgressHandler) progressComplition
              completion:(ResponseHandler) completion{
    
    NSDictionary *headers = @{ @"authorization": auth_token};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_BaseURL, path]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    
    __block NSURLSessionDataTask *task = [m_session dataTaskWithRequest:request
                                                      completionHandler:^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                                          self.urlCallback(task, responseData, response, error);
                                                      }];
    [task resume];
    
    if (progressComplition) {
        self.progressStorage[@(task.taskIdentifier)] = progressComplition;
    }
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
    
}
- (void) GETAllMessage:(NSString*)path
                    data:(NSDictionary*)data
                progress:(ProgressHandler) progressComplition
              completion:(ResponseHandler) completion{
    
    NSDictionary *headers = @{ @"authorization": auth_token};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_BaseURL, path]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    
    __block NSURLSessionDataTask *task = [m_session dataTaskWithRequest:request
                                                      completionHandler:^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                                          self.urlCallback(task, responseData, response, error);
                                                      }];
    [task resume];
    
    if (progressComplition) {
        self.progressStorage[@(task.taskIdentifier)] = progressComplition;
    }
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
    
}
- (void) GETVinliData:(NSString*)path
                    data:(NSDictionary*)data
                progress:(ProgressHandler) progressComplition
              completion:(ResponseHandler) completion{
    
    NSDictionary *headers = @{@"authorization": auth_token};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_BaseURL, path]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    
    __block NSURLSessionDataTask *task = [m_session dataTaskWithRequest:request
                                                      completionHandler:^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                                          self.urlCallback(task, responseData, response, error);
                                                      }];
    [task resume];
    
    if (progressComplition) {
        self.progressStorage[@(task.taskIdentifier)] = progressComplition;
    }
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
    
}

- (void) DELETE:(NSString*)path
           data:(NSDictionary*)data
     completion:(ResponseHandler) completion{
    [self DELETE:path data:data progress:nil completion:completion];
}

- (void) DELETE:(NSString*)path
           data:(NSDictionary*)data
       progress:(ProgressHandler) progressComplition
     completion:(ResponseHandler) completion{
    __block  NSURLSessionDataTask* task = [m_session dataTaskWithRequest:[self generateRequest:@"DELETE"
                                                                                          path:path
                                                                                          data:data]
                                                       completionHandler:
                                           ^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                               self.urlCallback(task, responseData, response, error);
                                           }];
    [task resume];
    if (progressComplition) {
        self.progressStorage[@(task.taskIdentifier)] = progressComplition;
    }
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
}

#pragma mark Response


#pragma mark Request

- (NSURLRequest*) generateRequest:(NSString*) method
                             path:(NSString*)path
                             data:(NSDictionary*)data {
    NSString *urlpath = [NSString stringWithFormat:@"%@%@", API_BaseURL, path];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlpath parameters:data error:nil];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (auth_token && [auth_token isEqualToString:@""]){
        NSString* tokenRepresentation = [NSString stringWithFormat:@"%@", auth_token];
        [request setValue:tokenRepresentation forHTTPHeaderField:@"Authorization"];
    }
    
    return request;
}

- (void) PATH:(NSString*)method data:(NSDictionary*)data handler:(ResponseHandler) handler{
    NSURLRequest* request = [self generateRequestWithFormData:@"POST"
                                                         path:method
                                                         data:data];
    
    __block  NSURLSessionDataTask* task = [m_session dataTaskWithRequest:request
                                                       completionHandler:
                                           ^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                               self.urlCallback(task, responseData, response, error);
                                           }];
    [task resume];
    if (handler) {
        self.completionStorage[@(task.taskIdentifier)] = handler;
    }
}

- (NSURLRequest*) generateRequestWithFormData:(NSString*)method path:(NSString*)path data:(NSDictionary*)data{
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:[NSString stringWithFormat:@"%@%@", API_BaseURL, path] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString *key in [data allKeys]) {
            NSObject *obj = data[key];
            if ([obj isKindOfClass:[NSData class]]) {
                [formData appendPartWithFileData:(NSData*)obj name:key fileName:@"profile.png" mimeType:@"image/jpeg"];
            } else if ([obj isKindOfClass:[NSString class]]) {
                NSString *strValue = (NSString *) obj;
                [formData appendPartWithFormData:[strValue dataUsingEncoding:NSUTF8StringEncoding] name:key];
            }
        }
    } error:nil];
    
//    if (auth_token){
//        NSString* tokenRepresentation = [NSString stringWithFormat:@"%@", auth_token];
//        [request setValue:auth_token forHTTPHeaderField:@"Authorization"];
//    }
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    return request;
}

- (NSURLRequest*) generateRequestWithQueryString:(NSString*)method
                                            path:(NSString*)path
                                            data:(NSDictionary*)data{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = method;
    request.timeoutInterval = 30;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[[self urlWithComponent:path] absoluteString]];
    
    NSMutableArray* query = [NSMutableArray new];
    for (NSString* key in data) {
        if([data[key] isKindOfClass:[NSArray class]]){
            for (id vType in data[key]) {
                [query addObject:[NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@",vType]]];
            }
        }else{
            [query addObject:[NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@",data[key]]]];
        }
    }
    components.queryItems = query;
    request.URL = [components URL];
    if(auth_token){
        NSDictionary *headers = @{ @"Authorization": auth_token};
        [request setAllHTTPHeaderFields:headers];
    }
    
    
    return request;
}

- (NSString*) postData : (NSDictionary*) dictionary {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

- (NSURL*) urlWithComponent:(NSString*)component{
    component = [NSString stringWithFormat:@"%@/",component];
    return [[NSURL URLWithString:API_BaseURL] URLByAppendingPathComponent:component];
}

#pragma mark NSURLSessionTaskDelegate


- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    ProgressHandler progress = self.progressStorage[@(task.taskIdentifier)];
    if (progress) {
        progress((float) totalBytesSent, (float) totalBytesExpectedToSend);
    }
}


@end
