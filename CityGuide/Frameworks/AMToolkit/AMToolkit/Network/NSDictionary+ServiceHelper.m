//
//  NSDictionary+ServiceHelper.m
//  AMToolkit
//
//  Created by Anton Kaizer on 25.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import "NSDictionary+ServiceHelper.h"

@implementation NSDictionary (ServiceHelper)

- (NSArray *) parseObjectsArrayFromArrayWithKey:(NSString *) key withClass:(Class) itemClass {
	if (![itemClass instancesRespondToSelector:@selector(initWithDictionary:)])
		[NSException raise:NSInvalidArgumentException format:@"%@ not responds to initWithDictionary", itemClass];
	
	NSMutableArray *result = [NSMutableArray array];
	NSArray *objectsArray = [self validObjectForKey:key];
	for (NSDictionary *objDict in objectsArray) {
		[result addObject:[[itemClass alloc] initWithDictionary:objDict]];
	}
	return result;
}

@end
