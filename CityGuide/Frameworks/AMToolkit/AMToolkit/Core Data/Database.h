/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Database : NSObject

+ (Database *) sharedDB;
- (void) refreshDB;
+ (void) save;

@property (nonatomic, readonly) BOOL readOnlyMode; //YES if we can't copy existing database from app to documents
@property (nonatomic, strong) NSPersistentStore *persistentStore;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, copy) NSString *databaseFileName;
@property (weak, nonatomic, readonly) NSString *databaseFilePath;
@property (nonatomic, copy) NSString *existingDatabasePath;
@property (nonatomic, copy) NSString *customDatabasePath;

@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, strong) NSDictionary *customStoreOptions;

@property (nonatomic) BOOL useDatabaseFromPreviousAppVersion DEPRECATED_ATTRIBUTE;

- (NSManagedObjectContext*) managedObjectContext;

@end
