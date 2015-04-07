//
//  ServiceProvider.m
//
//  Created by Anton Kaizer on 04.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import "AMServiceProvider.h"
#import "AMJSONRequestOperation.h"
#import "NSString+Validation.h"
#import "NSDictionary+Validation.h"
#import "NSString+SSToolkitAdditions.h"

@interface AMServiceProvider () 

@end

@implementation AMServiceProvider

#pragma mark singleton

+ (instancetype) sharedProvider {
	static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark public

- (id) initWithBaseURL:(NSURL *)url {
	if (self = [super initWithBaseURL:url]) {
		self.parameterEncoding = AFJSONParameterEncoding;
		_responseKey = @"response";
		self.enableLogging = YES;
		[self registerOperationClasses];
	}
	return self;
}

- (NSMutableURLRequest *) requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
	NSMutableURLRequest *request = nil;
	
	if ([self.requestEnvelope isValid] && !([method isEqualToString:@"GET"] || [method isEqualToString:@"HEAD"] || [method isEqualToString:@"DELETE"])) {
		request = [super requestWithMethod:method path:path parameters:nil];
		NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
		NSError *error = nil;
		NSString *requestString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error] encoding:self.stringEncoding];
		requestString = [NSString stringWithFormat:@"%@=%@", self.requestEnvelope, requestString];
		[request addValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:[requestString dataUsingEncoding:self.stringEncoding]];
	} else {
		request = [super requestWithMethod:method path:path parameters:parameters];
	}
	return request;
}

-  (AFHTTPRequestOperation *) HTTPRequestOperationWithRequest:(NSMutableURLRequest *) request serviceRequest:(AMServiceRequest *) serviceRequest success:(RequestSuccessCallback) success failure:(RequestFailCallback) failure {
	
	if ([serviceRequest acceptableContentType])
		[request setValue:[serviceRequest acceptableContentType] forHTTPHeaderField:@"Accept"];
	
	[self requestWillSend:request];
	
	[self log:@"request url:%@", request.URL];
	[self log:@"request headers:%@", request.allHTTPHeaderFields];
	if (request.HTTPBody.length > 0)
		[self log:@"request body: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:self.stringEncoding]];
	
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self log:@"Response code: %d", operation.response.statusCode];
		[self log:@"Response headers: %@", operation.response.allHeaderFields];
		if (([operation.response.MIMEType hasPrefix:@"application"] || [operation.response.MIMEType hasPrefix:@"text"])) {
			[self log:@"Response body: %@", [[NSString alloc] initWithData:operation.responseData encoding:self.stringEncoding]];
		}
		
		AMRequestError *error = [serviceRequest validateResponse:responseObject httpResponse:operation.response];
		if (error) {
			[self log:@"request error:%@", error];
			if (failure)
				failure(serviceRequest, error);
		} else {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				NSObject *validResponseObject = responseObject;
				if ([_responseKey isValid] && [validResponseObject isKindOfClass:[NSDictionary class]]) {
					validResponseObject = [(NSDictionary*)responseObject validObjectForKey:_responseKey];
				}
				[serviceRequest processResponse:validResponseObject];
				dispatch_async(dispatch_get_main_queue(), ^{
					if (success)
						success(serviceRequest);
				});
			});
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self log:@"Response code: %d", operation.response.statusCode];
		[self log:@"Response headers: %@", operation.response.allHeaderFields];
		if ([operation.response.MIMEType hasPrefix:@"application"] || [operation.response.MIMEType hasPrefix:@"text"]) {
			[self log:@"Response body: %@", [[NSString alloc] initWithData:operation.responseData encoding:self.stringEncoding]];
		}
		[self log:@"request error: %@", error];
		
		if (failure)
			failure(serviceRequest, error);
	}];
	
	return operation;
}

- (AFHTTPRequestOperation *) sendRequest:(AMServiceRequest *) serviceRequest toPath:(NSString *) path success:(RequestSuccessCallback) success failure:(RequestFailCallback) failure {
	NSDictionary *requestDict = [serviceRequest requestDictionary];
	
	NSMutableURLRequest *request = [self requestWithMethod:[serviceRequest method] path:path parameters:requestDict];
	
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request serviceRequest:serviceRequest success:success failure:failure];
	[self enqueueHTTPRequestOperation:operation];
	return operation;
}

- (AFHTTPRequestOperation *) sendRequest:(AMServiceRequest *) serviceRequest success:(RequestSuccessCallback) success failure:(RequestFailCallback) failure {
	return [self sendRequest:serviceRequest toPath:serviceRequest.path success:success failure:failure];
}

- (AFHTTPRequestOperation *) sendRequest:(AMServiceRequest *)serviceRequest withCompletionBlock:(void(^)(id request, NSError *requestError)) callback {
	if ([serviceRequest isKindOfClass:[AMFileRequest class]]) {
		if (((AMFileRequest *)serviceRequest).isUpload) {
			return [self uploadFileWithRequest:(AMFileRequest *)serviceRequest success:^(id request) {
				if (callback)
					callback(request, nil);
			} failure:^(id request, NSError *requestError) {
				if (callback)
					callback(request, requestError);
			}];
		} else {
			return [self downloadFileWithRequest:(AMFileRequest *)serviceRequest success:^(id request) {
				if (callback)
					callback(request, nil);
			} failure:^(id request, NSError *requestError) {
				if (callback)
					callback(request, requestError);
			}];
		}
	} else {
		return [self sendRequest:serviceRequest success:^(id request) {
			if (callback)
				callback(request, nil);
		} failure:^(id request, NSError *requestError) {
			if (callback)
				callback(request, requestError);
		}];
	}
}

#pragma mark private

- (void) registerOperationClasses {
	[self registerHTTPOperationClass: [AMJSONRequestOperation class]];
}

- (void) requestWillSend:(NSMutableURLRequest *) request {
	NSString *requestId = [NSString stringWithUUID];
	[request setValue:requestId forHTTPHeaderField:@"X-Request-id"];
	if (self.authorizationToken)
		[request setValue:self.authorizationToken forHTTPHeaderField:@"X-Auth-Token"];
	[self log:@"sending request with id:%@", requestId];
}

- (AFHTTPRequestOperation *) uploadFileWithRequest:(AMFileRequest *) fileRequest success:(RequestSuccessCallback) success failure:(RequestFailCallback) failure  {
	
	NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:fileRequest.path parameters:fileRequest.requestDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		NSError *error = nil;
		if (fileRequest.filePath) {
			[formData appendPartWithFileURL:[NSURL fileURLWithPath:fileRequest.filePath] name:[fileRequest formFileField] error:&error];
		} else if (fileRequest.fileData) {
			[formData appendPartWithFileData:fileRequest.fileData name:[fileRequest formFileField] fileName:fileRequest.fileName mimeType:@"application/octet-stream"];
		}
		if (error) {
			failure(fileRequest, error);
		}
	}];
	
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request serviceRequest:fileRequest success:success failure:failure];
	
	[self enqueueHTTPRequestOperation:operation];
	
	return operation;
}

- (AFHTTPRequestOperation *) downloadFileWithRequest:(AMFileRequest *) fileRequest success:(RequestSuccessCallback) success failure:(RequestFailCallback) failure  {
	
	NSMutableURLRequest *request = [self requestWithMethod:fileRequest.method path:fileRequest.path parameters:fileRequest.requestDictionary];

	[self requestWillSend:request];
	
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request serviceRequest:fileRequest success:success failure:failure];
	
	if ([fileRequest filePath]) {
		operation.outputStream = [NSOutputStream outputStreamToFileAtPath:[fileRequest filePath] append:NO];
	}
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self log:@"Response code: %d", operation.response.statusCode];
		[self log:@"Response headers: %@", operation.response.allHeaderFields];
		
		if (operation.response.statusCode == HTTP_OK) {
			if (![fileRequest filePath]) {
				fileRequest.fileData = operation.responseData;
				fileRequest.fileName = [fileRequest.path lastPathComponent];
			}
			if (success)
				success(fileRequest);
		} else {
			failure(fileRequest, [AMRequestError requestErrorWithCode:operation.response.statusCode description:@"Some server error occured."]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self log:@"request error:%@", error];
		failure(fileRequest, error);
	}];
    [self enqueueHTTPRequestOperation:operation];
	
	return operation;
}

- (void) log:(NSString *) logFormat, ... {
	if (self.enableLogging) {
		va_list argumentList;
		va_start(argumentList, logFormat);
			
		NSLogv(logFormat, argumentList);
			
		va_end(argumentList);
	}
}

#pragma mark -

@end
