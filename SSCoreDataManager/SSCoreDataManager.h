//
//  SSCoreDataManager.h
//  SSCoreDataManager
//
//  Created by Sam Spencer on 5/18/14.
//  Copyright (c) 2014 Sam Spencer. All rights reserved.
//

@import CoreData;
@protocol SSCoreDataManagerDelegate;


typedef enum : NSUInteger {
    /// Error that occurs when attempting to save an uninitialized managed object context.
    kCDMEInvalidManagedObjectContext = 3413500,
    /// Error that occurs when the persistant store location is invalid. A common cause of this is a read-only URL, or a destination that does not exist.
    kCDMEInvalidPersistentStoreLocation = 3413501,
    /// Error that occurs when the schema for the persistent store is incompatible with current managed object model. It may be necessary to delete the model or transition to a new model.
    kCDMEInvalidPersistentStoreModel = 3413502,
    /// Error that occurs when no model file name has been specified.
    kCDMEInvalidModelFileName = 3413503,
    /// Error that occurs when no SQLite file name has been specified.
    kCDMEInvalidSQLiteFileName = 3413504,
} /// Error codes which represent a variety of possible known errors which can occur while using Core Data.
kCoreDataManagerErrors;


/// Basic management interface for Core Data. Handles setup, retrieval, saving, and teardown of Core Data.
@interface SSCoreDataManager : NSObject

/// A shared instance of the current application's CoreData Manager
+ (SSCoreDataManager *)sharedManager;


/// This should be the \b first call made to CoreDataManager. This will perform any and all necessary setup. Additionally, it will create or initialize your SQLite and Model files.
- (NSManagedObjectContext *)setupDataAndSetSQLiteFileName:(NSString *)SQLiteName andModelFileName:(NSString *)modelName;

/// This should be the \b first call made to CoreDataManager. This will perform any and all necessary setup. Additionally, it will create or initialize your SQLite and Model files. If any specific persistent store options (eg. migration) are needed, specify them here.
- (NSManagedObjectContext *)setupDataAndSetSQLiteFileName:(NSString *)SQLiteName andModelFileName:(NSString *)modelName withPersistentStoreOptions:(NSDictionary *)options;

/// Automatically save the managed object context before the current app terminates. Only needs to be called once, during setup.
- (void)setShouldSaveContextOnAppTermination;

/// Automatically save the managed object context when the current app enters the background. Only needs to be called once, during setup.
- (void)setShouldSaveContextOnAppBackgrounding;


// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory;


/// Create a new CoreData managed object from the CoreData Model, and the entity name (should be the same as the class name specified in the model).
- (id)insertObjectForEntityWithName:(NSString *)entityName;


/// Delete a CoreData managed object from the CoreData Model.
- (void)deleteObject:(NSManagedObject *)object;


/// Save the current object context. Returns nil if there is no error or there are no changes to save.
- (NSError *)saveObjectContext;


/// Fetch an array of objects within the given entity
- (NSArray *)fetchEntityWithName:(NSString *)entityName;

/// Fetch an array of objects within the given entity, and sort the objects based on the specified entity attribute
- (NSArray *)fetchEntityWithName:(NSString *)entityName withSortAttribute:(NSString *)sortAttribute;

/// Fetch an array of objects within the given entity, and sort the objects in the specified order based on the specified entity attribute
- (NSArray *)fetchEntityWithName:(NSString *)entityName withSortAttribute:(NSString *)sortAttribute ascending:(BOOL)order;


/// Fetch an array of objects within the given entity and predicate filter.
- (NSArray *)fetchEntityWithName:(NSString *)entityName andPredicateFilter:(NSPredicate *)predicate;

/// Fetch an array of objects within the given entity and predicate filter. If more than one object is fetched they will be returned in the specified order.
- (NSArray *)fetchEntityWithName:(NSString *)entityName andPredicateFilter:(NSPredicate *)predicate withSortAttribute:(NSString *)sortAttribute ascending:(BOOL)order;



/// The delegate object of the CoreData Manager
@property (strong, nonatomic) id<SSCoreDataManagerDelegate> delegate;


/// Returns the managed object context for the application. If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// Returns the managed object model for the application. If the model doesn't already exist, it is created from the application's model.
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

// Returns the persistent store coordinator for the application. If the coordinator doesn't already exist, it is created and the application's store added to it.
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end


@protocol SSCoreDataManagerDelegate <NSObject>

- (void)coreDataManager:(SSCoreDataManager *)manager errorDidOccur:(NSError *)error;

@end

