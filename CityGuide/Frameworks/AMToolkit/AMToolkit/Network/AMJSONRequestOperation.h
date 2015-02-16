//
//  AMJSONRequestOperation.h
//  PullToRefreshSample
//
//  Created by Anton Kaizer on 11.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import "AFJSONRequestOperation.h"

@interface AMJSONRequestOperation : AFJSONRequestOperation

@property (nonatomic, copy) NSString *requestEnvelope;

@end
