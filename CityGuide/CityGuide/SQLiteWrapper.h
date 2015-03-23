//
//  SQLiteWrapper.h
//  CityGuide
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

@interface SQLiteWrapper : NSObject {
	@protected
	sqlite3 *database;
}

@property (nonatomic) NSInteger countError;
@property (strong, nonatomic) NSString *name;
@property (readonly, nonatomic) sqlite3 *database;

+ (instancetype) sharedInstance;

- (void) openDatabaseWithName:(NSString *) name;
- (void) openDatabase;
- (void) closeDatabase;
- (NSString *) checkFile;
- (void) errorSelectCurrent:(void(^)(id)) block;
- (NSString *) bundleName;

@end