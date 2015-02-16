/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "NSDictionary+Validation.h"


@implementation NSDictionary(Validation)

- (id) validObjectForKey: (id) key {
	NSObject *obj = [self objectForKey:key];
	if ([obj isKindOfClass:[NSNull class]])
		return nil;
	return obj;
}

- (BOOL) boolForKey: (id) key {
	if ([[self validObjectForKey:key] isEqual:@"True"]) {
		return YES;
	} else	if ([[self validObjectForKey:key] isEqual:@"False"]) {
		return NO;
	} else {
		return [[self validObjectForKey:key] boolValue];
	}
}

@end

@implementation NSMutableDictionary(Validation)

- (void) setObjectOrNSNull:(id)obj forKey: (id) key {
	if(obj != nil) {
		[self setObject: obj forKey:key];
		return;
	}
	
	[self setObject: [NSNull new] forKey:key];
}

- (void) setObjectOrDoNothing: (id) obj forKey: (id) key {
	if (obj != nil) {
		[self setObject: obj forKey: key];
		return;
	}
}

@end
