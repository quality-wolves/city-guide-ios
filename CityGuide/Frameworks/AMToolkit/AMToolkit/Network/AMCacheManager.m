//
//  AMCacheManager.m
//  AMToolkit
//
//  Created by Anton Kaizer on 05.03.14.
//  Copyright (c) 2014 Arello Mobile. All rights reserved.
//

#import "AMCacheManager.h"

@implementation AMCacheManager

+ (void) storeCachedData:(NSData *) data forUrl:(NSURL *) url cacheAge:(NSInteger) age lastModifiedDate:(NSDate *) date etag:(NSString *) etag {
    static NSString *lastModifiedStringFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
   
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (age != -1) {
        [headers setValue:[NSString stringWithFormat:@"max-age=%ld", (long)age] forKey:@"Cache-Control"];
    }
    if (date) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = lastModifiedStringFormat;
        df.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        [headers setValue:[df stringFromDate:date] forKey:@"Last-Modified"];
    }
    if (etag) {
        [headers setValue:etag forKey:@"ETag"];
    }
    
    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:[[NSHTTPURLResponse alloc] initWithURL:url statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headers] data:data];
    [[NSURLCache sharedURLCache] storeCachedResponse:cachedResponse forRequest:[NSURLRequest requestWithURL:url]];
}

@end
