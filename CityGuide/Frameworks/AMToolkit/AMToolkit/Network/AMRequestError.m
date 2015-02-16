/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "AMRequestError.h"


@implementation AMRequestError

+ (instancetype) requestErrorWithCode:(NSInteger) code description:(NSString *) description {
	return [[self class] errorWithDomain:kAMRequestErrorDomain code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]];
}

@end
