/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */


#import "Database.h"
#import "../Additions/NSString+Validation.h"

@interface Database () {
    NSManagedObjectContext *_writerContext;
    NSManagedObjectContext *_mainContext;
    NSObject *_lock;
}

- (NSString *) applicationDocumentsDirectory;

@property (nonatomic) BOOL readOnlyMode;
@property (nonatomic) NSMutableDictionary *contexts;

@end

static Database *instance;
@implementation Database

- (id) init {
	if (self = [super init]) {
        _lock = [NSObject new];
		_useDatabaseFromPreviousAppVersion = NO;
        _contexts = [NSMutableDictionary dictionary];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadWillExit:) name:NSThreadWillExitNotification object:nil];
	}
	return self;
}

+ (Database *) sharedDB {
	if (instance == nil) {
		instance = [Database new];
	}
	
	return instance;
}

+ (void) save {
    [[self sharedDB] saveContext:[self sharedDB].managedObjectContext];
}

- (void) saveContext: (NSManagedObjectContext*) context {
    if ([context hasChanges]) {
        [context performBlockAndWait:^{
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"%@", error.localizedDescription);
            }
            if (context.parentContext) {
                [self saveContext:context.parentContext];
            }
        }];
    }
}

- (void) refreshDB {
    _persistentStore = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectModel = nil;
    _writerContext = nil;
    _mainContext = nil;
    _contexts = nil;
}

- (void) threadWillExit:(NSNotification*) notification {
    if([notification.name isEqualToString:NSThreadWillExitNotification]){
        NSThread *thread = notification.object;
        [self removeContextForThreadWithName:thread.name];
    }
}

- (void) removeContextForThreadWithName:(NSString*) threadName {
    @synchronized(_lock) {
        NSManagedObjectContext *context = [_contexts objectForKey:threadName];
        if(context) {
            [context save:nil];
            [_contexts removeObjectForKey:[NSThread currentThread].name];
        }
    }
}

- (NSString *) applicationDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;
}

static int threadIdCounter = 0;

- (NSManagedObjectContext *) managedObjectContext {
    if (!_mainContext) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            _writerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            _writerContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
            [_writerContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        });
        
        if ([NSThread isMainThread]) {
            _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            });
        }
        [_mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        _mainContext.parentContext = _writerContext;
    }
    
    if ([NSThread isMainThread]) {
        return _mainContext;
    }
    
    NSString *name = [NSThread currentThread].name;
    if(![name isValid]) {
        name = [NSString stringWithFormat:@"thread%d", threadIdCounter++];
        [NSThread currentThread].name = name;
    }
    NSManagedObjectContext *context = [_contexts objectForKey:name];
    if (!context) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        context.parentContext = _mainContext;
        [_contexts setObject:context forKey:name];
    }

    return context;
}

- (NSManagedObjectModel *) managedObjectModel {
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	
	if ([_modelName isValid]) {
		NSString *path = [[NSBundle mainBundle] pathForResource:_modelName ofType:@"momd"];
				
		if (path) {
			NSURL *momURL = [NSURL fileURLWithPath:path];
			_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
        } else {
			_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        }
    } else {
		_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
	
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
    NSURL *storeUrl = nil;
    if ([_customDatabasePath isValid]) {
        storeUrl = [NSURL fileURLWithPath:_customDatabasePath];
    } else {
        NSString *path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[self databaseFileName]];
        storeUrl = [NSURL fileURLWithPath: path];
        
        if ([_existingDatabasePath isValid]) {
            NSFileManager* fileManager = [NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:path]) {
                NSError* error = nil;
                [fileManager copyItemAtPath:_existingDatabasePath toPath:path error:&error];
                
                if (error) {
                    NSLog(@"Error while copying existing DB: %@", error);
                    _readOnlyMode = YES;
                    storeUrl = [NSURL fileURLWithPath:self.existingDatabasePath];
                } else {
                    _readOnlyMode = NO;
                }
            }
        }
    }
	
    NSLog(@"Database store path: %@", storeUrl.path);
    
	NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],			
							 NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], 
								NSInferMappingModelAutomaticallyOption
							 , nil];
	
	if (_readOnlyMode) {
		[options setObject:@(YES) forKey:NSReadOnlyPersistentStoreOption];
	}
	
	if (self.customStoreOptions != nil) {
		[options addEntriesFromDictionary:self.customStoreOptions];
	}
		
	NSError *error;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	self.persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error];
	if (!_persistentStore) {
		// Handle the error.
		NSLog(@"Error while creating persistent store: %@", error);
        
        // if sqlite database is corrupted replace it from resources
        if ([_existingDatabasePath isValid] && error.code == 259) {
            NSFileManager* fileManager = [NSFileManager defaultManager];
            NSMutableArray *filePathes = [[fileManager contentsOfDirectoryAtPath:[self applicationDocumentsDirectory] error:nil] mutableCopy];
            for (NSString *fileName in filePathes) {
                if ([fileName containsString:[self databaseFileName]]) {
                    [[NSFileManager defaultManager] removeItemAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:fileName] error:nil];
                }
            }
            
            [fileManager copyItemAtPath:_existingDatabasePath toPath:storeUrl.absoluteString error:&error];
            error = nil;
            self.persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error];
            
            if (!_persistentStore) {
                NSLog(@"Error while creating persistent store: %@", error);
            }
        }
	}
	
	return _persistentStoreCoordinator;
}

- (NSString *) databaseFileName {
    if ([_customDatabasePath isValid]) {
        return [_customDatabasePath lastPathComponent];
    }
    
	NSMutableString *ret = [NSMutableString string];
	
	if (_databaseFileName != nil && [_databaseFileName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])
		[ret appendString:_databaseFileName];
	else {
		NSString *appName = [[NSProcessInfo processInfo] processName];	
		[ret appendString:[appName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];		
	}
	
	[ret appendString:@".sqlite"];
	
	if (_useDatabaseFromPreviousAppVersion) { //back capability. old version of wraper generated database name from processName + appVersion
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:[self applicationDocumentsDirectory]];
		
		NSString *appName = [[[NSProcessInfo processInfo] processName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];	
		
		NSMutableArray *databasesFiles = [NSMutableArray arrayWithArray:[[directoryEnumerator allObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self contains %@", appName]]];
		
		[databasesFiles sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
		
		if ([databasesFiles count] > 0) {
			[ret setString:[databasesFiles lastObject]];
		}
	}
	
	return ret;
}

- (NSString *) databaseFilePath {
    if ([_customDatabasePath isValid]) {
        return _customDatabasePath;
    }
    
	if (_readOnlyMode) {
		return self.existingDatabasePath;
	}
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[self databaseFileName]];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSThreadWillExitNotification object:nil];
}

@end
