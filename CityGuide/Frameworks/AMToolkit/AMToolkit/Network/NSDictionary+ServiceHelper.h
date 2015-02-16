//
//  NSDictionary+ServiceHelper.h
//  AMToolkit
//
//  Created by Anton Kaizer on 25.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMServiceObject.h"
#import "NSDictionary+Validation.h"

@interface NSDictionary (ServiceHelper)

- (NSArray *) parseObjectsArrayFromArrayWithKey:(NSString *) key withClass:(Class) itemClass;

@end
