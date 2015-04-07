//
//  BaseData.m
//  CityGuide
//

#import "BaseData.h"

#define kCasheCountLimit 14000

@interface DBCache : NSCache
@end

@implementation DBCache

+ (DBCache *)sharedDBCache {
    static DBCache *_dbCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _dbCache = [[DBCache alloc] init];
    });
    
    return _dbCache;
}

- (id)init {
    if (self = [ super init]) {
        [self setCountLimit:kCasheCountLimit];
    }
    return self;
}

@end

@implementation BaseData

//request example = [NSString stringWithFormat:@"SELECT uid,name FROM cantons WHERE name like '%@%%'", search];
+ (NSArray *) sendRequest:(NSString *) request converter:(StmtConverter) converter {
	sqlite3_stmt *db_statement = nil;
	const char *readyQuery = [request cStringUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableArray *requestResult = [NSMutableArray array];
    int statusRequest = sqlite3_prepare_v2([SQLiteWrapper sharedInstance].database, readyQuery, -1, &db_statement, NULL);
    
    if(statusRequest != SQLITE_OK) {
        for (int i = 0; i < 10; i++) {
            NSLog(@"Count repeat -%d Status request %@ with request %@", i, @(statusRequest).stringValue, request);
            [[SQLiteWrapper sharedInstance] closeDatabase];
            [[SQLiteWrapper sharedInstance] openDatabaseWithName: @"db.sqlite3"];
            statusRequest = sqlite3_prepare_v2([SQLiteWrapper sharedInstance].database, readyQuery, -1, &db_statement, NULL);
            if (statusRequest == SQLITE_OK) {
                break;
            }
        }
    }
	if(statusRequest == SQLITE_OK) {
		while (sqlite3_step (db_statement) == SQLITE_ROW) {
			[requestResult addObject:converter(db_statement)];
		}
	}
    if (!requestResult.count) {
        NSLog(@"Status request %@ with request %@", @(statusRequest).stringValue, request);
    }
	return requestResult;
}

+ (id) cacheId:(int) uid {
    return [[DBCache sharedDBCache] objectForKey:@(uid)];
}

- (void) setCacheObjectId:(int) uid {
    [[DBCache sharedDBCache] setObject:self forKey:@(uid)];
}

#pragma mark - Created Methods

+ (BOOL) createTableWithName:(NSString *) name rows:(NSArray *) rows {
    NSString *query = [NSString stringWithFormat:@"create table %@(%@)", name, [[rows valueForKey:@"description"] componentsJoinedByString:@", "]];
    return [self createRequest:query];
}

+ (BOOL) createRequest:(NSString *) request {
    char *errorMessage;
	const char *readyQuery = [request cStringUsingEncoding:NSUTF8StringEncoding];
    if (sqlite3_exec([SQLiteWrapper sharedInstance].database, readyQuery, NULL, NULL, &errorMessage) == SQLITE_OK) {
        return YES;
    }
    NSLog(@"%@", [NSString stringWithUTF8String:errorMessage]);
    return NO;
}

#pragma mark - Additions Methods


@end

@implementation NSString (BaseData)

- (NSString *) validSearch {
    return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

@end

