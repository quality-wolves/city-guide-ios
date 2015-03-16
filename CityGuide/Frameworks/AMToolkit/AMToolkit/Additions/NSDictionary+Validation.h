/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import <Foundation/Foundation.h>


@interface NSDictionary(Validation)

- (id) validObjectForKey: (id) key;
- (BOOL) boolForKey: (id) key;

@end

@interface NSMutableDictionary(Validation)

- (void) setObjectOrNSNull:(id)obj forKey: (id) key;
- (void) setObjectOrDoNothing: (id) obj forKey: (id) key;

@end
