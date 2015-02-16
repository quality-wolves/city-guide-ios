//
//  AMServiceObject.h
//  AMToolkit
//
//  Created by Anton Kaizer on 25.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMServiceObject <NSObject>

@optional
- (id) initWithDictionary:(NSDictionary *) dictionary;
- (NSDictionary *) dictionaryRepresentation;

@end
