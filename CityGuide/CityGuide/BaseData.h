//
//  BaseData.h
//  CityGuide
//

#import <Foundation/Foundation.h>
#import "SQLiteWrapper.h"

typedef id(^StmtConverter)(sqlite3_stmt *stmt);

@interface BaseData : NSObject

// Request example: [NSString stringWithFormat:@"SELECT uid,name FROM cantons WHERE name like '%@%%'", search];

+ (NSArray *) sendRequest:(NSString *) request converter:(StmtConverter) converter;
+ (id) cacheId:(int) uid;
- (void) setCacheObjectId:(int) uid;

#pragma mark - Created Methods

+ (BOOL) createTableWithName:(NSString *) name rows:(NSArray *) rows;
+ (BOOL) createRequest:(NSString *) request;

@end

@interface NSString (BaseData)

- (NSString *) validSearch;

@end