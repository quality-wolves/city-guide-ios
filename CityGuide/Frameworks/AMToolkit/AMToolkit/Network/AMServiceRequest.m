/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "AMServiceRequest.h"
#import "NSString+Validation.h"
#import "NSDictionary+Validation.h"

@implementation AMServiceRequest;

- (NSString *) acceptableContentType {
	return @"application/json";
}

- (NSString *) method {
	return @"POST";
}

- (NSString *) path {
	return @"(request_path_here)";
}

- (NSDictionary *) requestDictionary {
	return [NSDictionary dictionary];
}

- (void) processResponse: (NSObject *) response {
	
}

- (AMRequestError *) validateResponse:(NSDictionary*) responseDictionary httpResponse:(NSHTTPURLResponse *) httpResponse {
	if (httpResponse.statusCode != HTTP_OK) {
		NSString *errorMessage = [responseDictionary validObjectForKey:@"error"];
		if (errorMessage)
			return [AMRequestError requestErrorWithCode:httpResponse.statusCode description:errorMessage];
		else
			return [AMRequestError requestErrorWithCode:httpResponse.statusCode description:@"Some server error occured."];
	}
	
	return nil;
}

@end