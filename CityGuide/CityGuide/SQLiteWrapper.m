//
//  SQLiteWrapper.m
//  CityGuide
//

#import "SQLiteWrapper.h"

@interface SQLiteWrapper()

@end

@implementation SQLiteWrapper

#define kMaxCountTry 5.0f

+ (instancetype) sharedInstance {
	static id instance = nil;
    static dispatch_once_t onceToken;
	
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id) init {
    if (self = [super init]) {
        self.name = @"db.sqlite3";
    }
    return self;
}

#pragma mark - File Methods

- (NSString *) bundleName {
    return self.name;
}

- (NSString *) databaseBundlePath {
	return [[NSBundle mainBundle] pathForResource:[self bundleName] ofType:nil];
}

- (NSString *) databasePath {
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [[NSString alloc] initWithString:[docPath stringByAppendingPathComponent:self.name]];
}

- (NSString *) checkFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *databasePath = [self databasePath];
    NSLog(@"%@", databasePath);
	if ([fileManager fileExistsAtPath:databasePath] == NO) {
		NSError *copyFileError;
		[fileManager copyItemAtPath:[self databaseBundlePath] toPath:databasePath error:&copyFileError];
		if (copyFileError) {
			[NSException raise:@"Copy file" format:@"%@", copyFileError];
		}
	}
	return databasePath;
}

- (void) openDatabaseWithName:(NSString *) name {
	self.name = name;
	[self openDatabase];
}

- (void) openDatabase {
	NSString *file = [self checkFile];
	if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
		NSLog(@"sqlite3_open = SQLITE_OK - %@", file);
	}
	else {
		[NSException raise:@"Open database" format:@"%@", file];
	}
}

- (void) closeDatabase {
	sqlite3_close(database);
}

- (sqlite3 *) database {
	return database;
}

- (void) errorSelectCurrent:(void(^)(id object)) block {
    [SQLiteWrapper sharedInstance].countError++;
    NSError *error = nil;
    if ([SQLiteWrapper sharedInstance].countError < kMaxCountTry) {
        [[SQLiteWrapper sharedInstance] closeDatabase];
        [[SQLiteWrapper sharedInstance] openDatabase];
    }
    else {
        error = [NSError errorWithDomain:@"sqlite2.agora.open" code:-kMaxCountTry userInfo:@{NSLocalizedDescriptionKey : @"Open database Error"}];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        block(error);
    });
}

@end
