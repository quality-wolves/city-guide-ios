/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */


#import <Foundation/Foundation.h>
#import "Database.h"


@interface NSManagedObject (Database)

+(Database*) database;
+(NSString*) entityName;

+ (NSArray *) executeFetchRequest: (NSFetchRequest *) request withError: (NSError **) error;
+ (NSArray *) allObjects;

+ (NSArray *) allObjectsSorted;
+ (NSArray *) allObjectsSortedByKey:(NSString*) key;
+ (NSArray *) allObjectsSortedByKey:(NSString*) key ascending:(BOOL)ascending;

+ (NSEntityDescription *) entityDescription;
- (NSEntityDescription *) entityDescription;
+ (NSArray *) findByCriteria: (NSString *) criteriaString, ...;
+ (id) findFirstByCriteria: (NSString *) criteriaString, ...;

- (int) intObjectID;

+ (id) create;
- (BOOL) save;
- (void) delete;
- (void) revert;

+ (void) removeAll;

+ (id) findByIntObjectID: (int) intObjectID;

+ (BOOL) saveContext;

@end
