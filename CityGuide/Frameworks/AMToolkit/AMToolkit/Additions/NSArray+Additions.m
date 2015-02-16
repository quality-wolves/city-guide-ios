//
//  Created by Anton Kaizer on 21.07.12.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSArray *) arrayWithConverter:(AMObjectConverter) converter {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id item in self) {
        [result addObject:converter(item)];
    }
    return result;
}

- (NSArray *) filteredArrayUsingBlock:(AMPredicateBlock) block {
	NSMutableArray* result = [NSMutableArray array];
    for (id item in self) {
		if (block(item))
			[result addObject:item];
    }
    return result;
}

- (NSArray *) sortedArrayWithWeightBlock:(AMWeightBlock) block {
	return  [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger weight1 = block(obj1);
        NSInteger weight2 = block(obj2);
        if (weight2 == NSNotFound || weight2 > weight1)
            return NSOrderedAscending;
        else if (weight1 == NSNotFound || weight1 > weight2)
            return NSOrderedDescending;
        return NSOrderedSame;
    }];
}

- (id) firstObjectPassedPredicateBlock:(AMPredicateBlock) block {
	for (id item in self) {
		if (block(item))
			return item;
    }
	return nil;
}

+ (BOOL) compareArray:(NSArray *) array1 withArray:(NSArray *) array2 usingComparatorBlock:(AMSimpleComparator) block {
	if ((array1.count == 0 || array1 == nil) && (array2.count == 0 || array2 == nil) )
		return YES;
	if (array2.count != array1.count)
        return NO;
    NSMutableArray *arrayCopy = [array1 mutableCopy];
    for (id obj1 in array2) {
        for (id obj2 in arrayCopy) {
            if (block(obj1, obj2)) {
				[arrayCopy removeObject:obj2];
				break;
            }
        }
    }
    return [arrayCopy count] == 0;
}

- (NSArray *) arrayByRemovingObjectsFromArray:(NSArray *) array {
	return [self filteredArrayUsingBlock:^BOOL(id obj) {
		return ![array containsObject:obj];
	}];
}

- (BOOL) containsObject:(id)anObject passedComparator:(AMSimpleComparator) block {
	id obj = [self firstObjectPassedPredicateBlock:^BOOL(id obj) {
		return block(obj, anObject);
	}];
	return obj != nil;
}

@end
