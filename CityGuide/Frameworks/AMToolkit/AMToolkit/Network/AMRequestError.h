/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import <Foundation/Foundation.h>
#import "AMHTTPStatusCodes.h"

#define kAMRequestErrorDomain @"AMRequestErrorDomain"

@interface AMRequestError : NSError

+ (instancetype) requestErrorWithCode:(NSInteger) code description:(NSString *) description;


@end
