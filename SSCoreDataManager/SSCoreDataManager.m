//
//  SSCoreDataManager.m
//  SSCoreDataManager
//
//  Created by Sam Spencer on 5/18/14.
//  Copyright (c) 2014 Sam Spencer. All rights reserved.
//

#import "SSCoreDataManager.h"

@interface SSCoreDataManager ()
@property (nonatomic, strong) NSString *SQLiteFileName;
@property (nonatomic, strong) NSString *ModelFileName;
@property (nonatomic, strong) NSDictionary *persistentStoreOptions;
@end

@implementation SSCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Lifecycle

+ (SSCoreDataManager *)sharedManager {
    static SSCoreDataManager *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationWillTerminateNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationDidEnterBackgroundNotification];
}

#pragma mark - Setup

- (void)setShouldSaveContextOnAppTermination {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveObjectContext) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)setShouldSaveContextOnAppBackgrounding {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveObjectContext) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (NSManagedObjectContext *)setupDataAndSetSQLiteFileName:(NSString *)SQLiteName andModelFileName:(NSString *)modelName {
    return [self setupDataAndSetSQLiteFileName:SQLiteName andModelFileName:modelName withPersistentStoreOptions:nil];
}

- (NSManagedObjectContext *)setupDataAndSetSQLiteFileName:(NSString *)SQLiteName andModelFileName:(NSString *)modelName withPersistentStoreOptions:(NSDictionary *)options {
    self.SQLiteFileName = SQLiteName;
    self.ModelFileName = modelName;
    self.persistentStoreOptions = options;
    
    return [self managedObjectContext];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
    if (_managedObjectContext != nil) return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    
    if (_managedObjectModel != nil) return _managedObjectModel;
    
    if (self.ModelFileName == nil) {
        NSError *error = [NSError errorWithDomain:@"Failed to create managed object model. Invalid model file name. Call setupDataAndSetSQLiteFileName:andModelFileName: to set the model file." code:kCDMEInvalidModelFileName userInfo:nil];
        if ([self.delegate respondsToSelector:@selector(coreDataManager:errorDidOccur:)]) [self.delegate coreDataManager:self errorDidOccur:error];
        
        return nil;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.ModelFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    
    if (_persistentStoreCoordinator != nil) return _persistentStoreCoordinator;
    
    if (self.SQLiteFileName == nil) {
        NSError *error = [NSError errorWithDomain:@"Failed to create persistent store coordinator. Invalid SQLite file name. Call setupDataAndSetSQLiteFileName:andModelFileName: to set the SQLite file." code:kCDMEInvalidSQLiteFileName userInfo:nil];
        if ([self.delegate respondsToSelector:@selector(coreDataManager:errorDidOccur:)]) [self.delegate coreDataManager:self errorDidOccur:error];
        
        return nil;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.SQLiteFileName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:self.persistentStoreOptions error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        if (error.code == 134100) {
            NSError *processedError = [NSError errorWithDomain:@"The model used to open the store is incompatible with the one used to create the store" code:kCDMEInvalidPersistentStoreModel userInfo:@{@"Persistent Store" : _persistentStoreCoordinator}];
            if ([self.delegate respondsToSelector:@selector(coreDataManager:errorDidOccur:)]) [self.delegate coreDataManager:self errorDidOccur:processedError];
        } else if (error.code == 513) {
            NSError *processedError = [NSError errorWithDomain:@"The persistent store is not accessible because of a permission problem (cannot write to file / directory)" code:kCDMEInvalidPersistentStoreLocation userInfo:@{@"Persistent Store" : _persistentStoreCoordinator}];
            if ([self.delegate respondsToSelector:@selector(coreDataManager:errorDidOccur:)]) [self.delegate coreDataManager:self errorDidOccur:processedError];
        } else {
            if ([self.delegate respondsToSelector:@selector(coreDataManager:errorDidOccur:)]) [self.delegate coreDataManager:self errorDidOccur:error];
            NSLog(@"[CoreData Error] UNRESOLVED - %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Editing

- (id)insertObjectForEntityWithName:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

- (void)deleteObject:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}

#pragma mark - Saving

- (NSError *)saveObjectContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return error;
        } else return nil;
    } else return [NSError errorWithDomain:@"Failed to save context. Invalid managed object context. The managed object context cannot be nil." code:kCDMEInvalidManagedObjectContext userInfo:nil];
}

#pragma mark - Fetching

- (NSArray *)fetchEntityWithName:(NSString *)entityName {
    return [self fetchEntityWithName:entityName withSortAttribute:nil ascending:NO];
}

- (NSArray *)fetchEntityWithName:(NSString *)entityName withSortAttribute:(NSString *)sortAttribute {
    return [self fetchEntityWithName:entityName withSortAttribute:sortAttribute ascending:NO];
}

- (NSArray *)fetchEntityWithName:(NSString *)entityName withSortAttribute:(NSString *)sortAttribute ascending:(BOOL)order {
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    if (sortAttribute) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortAttribute ascending:order];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
    }
    
    NSError *error;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error && [self.delegate respondsToSelector:@selector(coreDataManager:errorDidOccur:)]) [self.delegate coreDataManager:self errorDidOccur:error];
    
    return results;
}

- (NSArray *)fetchEntityWithName:(NSString *)entityName andPredicateFilter:(NSPredicate *)predicate {
    return [self fetchEntityWithName:entityName andPredicateFilter:predicate withSortAttribute:nil ascending:NO];
}

- (NSArray *)fetchEntityWithName:(NSString *)entityName andPredicateFilter:(NSPredicate *)predicate withSortAttribute:(NSString *)sortAttribute ascending:(BOOL)order {
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    
    if (sortAttribute) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortAttribute ascending:order];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
    }
    
    NSError *error;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error && [self.delegate respondsToSelector:@selector(coreDataManager:errorDidOccur:)]) [self.delegate coreDataManager:self errorDidOccur:error];
    
    return results;
}

@end
