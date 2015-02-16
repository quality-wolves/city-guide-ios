/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import <Foundation/Foundation.h>
#import "AMRequestError.h"
#import "AMHTTPStatusCodes.h"

@interface AMServiceRequest : NSObject

//to override
- (NSString *) acceptableContentType;
- (NSString *) method;
- (NSString *) path;
- (NSDictionary *) requestDictionary;
- (void) processResponse: (NSObject *) response;
- (AMRequestError *) validateResponse:(NSDictionary*) responseDictionary httpResponse:(NSHTTPURLResponse *) httpResponse;

@end



