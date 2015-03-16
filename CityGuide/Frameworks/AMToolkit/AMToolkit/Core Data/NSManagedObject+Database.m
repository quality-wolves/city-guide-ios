/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */


#import "NSManagedObject+Database.h"
#import <objc/runtime.h>
#import "../Additions/NSObject+ClassName.h"

@implementation NSManagedObject (Database)

- (id) init {
	if (self = [self initWithEntity:[[self class] entityDescription] insertIntoManagedObjectContext:[[[self class] database] managedObjectContext]]) {
		
	}
	
	return self;
}

- (int) intObjectID {
	NSURL *url = [[self objectID] URIRepresentation];
	NSString *pID = [[url absoluteString] lastPathComponent];
	NSRange intRange = [pID rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
	NSUInteger index = 0;
	if (intRange.location != NSNotFound) {
		index = intRange.location;
	}
	
	return [[pID substringFromIndex:index] intValue];
}

+ (id) findByIntObjectID: (int) intObjectID {
	//x-coredata://FF88B1B9-3E82-4180-B1FF-C38821BD249D/Product/p1226
	NSString *storeID = [[self database].persistentStore identifier];
	NSString *className = [self className];
	NSString *ID = [NSString stringWithFormat:@"%@%d", [className substringToIndex:1], intObjectID];
	NSString *absoluteString = [NSString stringWithFormat:@"x-coredata://%@/%@/%@", storeID, className, ID];
	NSURL *objectIDURL = [NSURL URLWithString:absoluteString];
	NSManagedObjectID* objectID = [[self database].persistentStoreCoordinator managedObjectIDForURIRepresentation:objectIDURL];
	return [[self database].managedObjectContext objectWithID:objectID];
}

+ (void) logError: (NSError *) error {
	NSLog(@"Error: %@", error);
	NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
	if(detailedErrors != nil && [detailedErrors count] > 0) {
		for(NSError* detailedError in detailedErrors) {
			NSLog(@"  DetailedError: %@", [detailedError userInfo]);
		}
	} else {
		NSLog(@"  %@", [error userInfo]);
	}
}

+(NSString*) entityName
{
	return [self className];
}

+(Database*) database
{
	return [Database sharedDB];
}

+ (NSEntityDescription *) entityDescription {
	return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:[[self database] managedObjectContext]];
}

- (NSEntityDescription *) entityDescription {
	return [[self class] entityDescription];
}

+ (NSArray *) executeFetchRequest: (NSFetchRequest *) request withError: (NSError **) error {
	NSEntityDescription *entity = [self entityDescription];
	
	[request setEntity:entity];
	
	NSArray *result = [[[self database] managedObjectContext] executeFetchRequest:request error:error];
	return result;
}

+ (NSArray *) allObjects {
	NSFetchRequest *allObjectsRequest = [[NSFetchRequest alloc] init];
	
	NSError* error = nil;
	NSArray *result = [self executeFetchRequest:allObjectsRequest withError:&error];
	
	if (error)
		NSLog(@"%@", error);
	
	return result;
}

+ (NSArray *) allObjectsSorted {
	return [self allObjectsSortedByKey:@"displayOrder" ascending:YES];
}

+ (NSArray *) allObjectsSortedByKey:(NSString*) key {
	return [self allObjectsSortedByKey:key ascending:YES];
}

+ (NSArray *) allObjectsSortedByKey:(NSString*) key ascending:(BOOL)ascending {
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:key ascending:ascending];
	NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
	
	NSFetchRequest *allObjectsRequest = [[NSFetchRequest alloc] init];
	[allObjectsRequest setSortDescriptors:sortDescriptors];
	NSArray *result = [self executeFetchRequest:allObjectsRequest withError:nil];
	
	return result;
}

+ (BOOL) saveContext {
	NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = [self database].managedObjectContext;
	if (managedObjectContext != nil) {
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			[self logError: error];
			return NO;
		}
		return YES;
	}
	return NO;
}


- (BOOL) save {
	return [[self class] saveContext];
}

- (void) revert {
	[[[self class] database].managedObjectContext refreshObject:self mergeChanges:NO];	
}

+ (NSArray *) findByCriteria: (NSString *) criteriaString, ...{
	va_list argumentList;
	va_start(argumentList, criteriaString);
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:criteriaString arguments:argumentList];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setPredicate:predicate];
	
	va_end(argumentList);
	
	NSError *error = nil;
	NSArray *result = [[self class] executeFetchRequest:request withError:&error];
	
	if (error)
		[[self class] logError: error];
	return result;
}

+ (id) findFirstByCriteria: (NSString *) criteriaString, ...{
	va_list argumentList;
	va_start(argumentList, criteriaString);
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:criteriaString arguments:argumentList];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.fetchLimit = 1;
    [request setPredicate:predicate];
	
	va_end(argumentList);
	
	NSError *error = nil;
	NSArray *result = [[self class] executeFetchRequest:request withError:&error];
	
	if (error)
		[[self class] logError: error];
	
	if ([result count])
		return [result objectAtIndex:0];
	
	return nil;
}

+ (NSArray *) findByCriteriaSorted: (NSString *) criteriaString, ...{
	va_list argumentList;
	va_start(argumentList, criteriaString);
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:criteriaString arguments:argumentList];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setPredicate:predicate];
	
	va_end(argumentList);
	
	NSError *error = nil;
	NSArray *result = [[self class] executeFetchRequest:request withError:&error];
	
	if (error)
		[[self class] logError: error];
	
	return result;
}


#pragma mark -
#pragma mark NSObject Overrides 

+ (id) create {
	NSManagedObject *newEmployee = [NSEntityDescription
									insertNewObjectForEntityForName:[self entityName]
 									inManagedObjectContext:[[self database] managedObjectContext]];
	
	return newEmployee;
}

- (void) delete {
	[[Database sharedDB].managedObjectContext deleteObject:self];
	[Database save];
}

+ (void) removeAll
{
	NSArray* allObjects = [self allObjects];
	
	for (NSManagedObject* object in allObjects)
		[object delete];
	
	[self saveContext];
}

@end
