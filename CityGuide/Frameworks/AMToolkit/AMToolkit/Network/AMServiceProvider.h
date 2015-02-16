//
//  ServiceProvider.h
//  asdasdasd
//
//  Created by Anton Kaizer on 04.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import "AMServiceRequest.h"
#import "AMRequestError.h"
#import "AFNetworking.h"
#import "AMFileRequest.h"

typedef void (^RequestSuccessCallback)(id request);
typedef void (^RequestFailCallback)(id request, NSError *requestError);

@interface AMServiceProvider : AFHTTPClient

@property (nonatomic, copy) NSString *requestEnvelope;
@property (nonatomic, copy) NSString *responseKey;
@property (nonatomic, copy) NSString *authorizationToken;
@property (nonatomic) BOOL enableLogging;

- (AFHTTPRequestOperation *) sendRequest:(AMServiceRequest *) serviceRequest toPath:(NSString *) path success:(RequestSuccessCallback) success failure:(RequestFailCallback) failure;
- (AFHTTPRequestOperation *) sendRequest:(AMServiceRequest *) serviceRequest success:(RequestSuccessCallback) success failure:(RequestFailCallback) failure;
- (AFHTTPRequestOperation *) sendRequest:(AMServiceRequest *)serviceRequest withCompletionBlock:(void(^)(id request, NSError *requestError)) callback;
+ (instancetype) sharedProvider;
- (AFHTTPRequestOperation *) uploadFileWithRequest:(AMFileRequest *) fileRequest success:(RequestSuccessCallback) success failure:(RequestFailCallback) failure;
- (AFHTTPRequestOperation *) downloadFileWithRequest:(AMFileRequest *) fileRequest success:(RequestSuccessCallback) success failure:(RequestFailCallback) failure;


//can be overrided in subclasses
- (void) registerOperationClasses;
- (void) requestWillSend:(NSMutableURLRequest *) request;

@end
