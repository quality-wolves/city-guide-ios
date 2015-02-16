//
//  AMCacheManager.h
//  AMToolkit
//
//  Created by Anton Kaizer on 05.03.14.
//  Copyright (c) 2014 Arello Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMCacheManager : NSObject

//pushes custom data into NSURLCache for given url
+ (void) storeCachedData:(NSData *) data forUrl:(NSURL *) url cacheAge:(NSInteger) age lastModifiedDate:(NSDate *) date etag:(NSString *) etag;

@end
