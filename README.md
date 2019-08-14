> :warning: The nature of CoreData has changed significantly since the original time of writing of this tool. Since I wrote this, Apple has seriously stepped up their game in regards to simplifying the initialization process, making multithreading safe, and providing straightforward iCloud sync. As such (and this is a good thing), I am sunsetting :sunset: this project and leaving it here only for historical / portfolio purposes.

SSCoreDataManager
===============

A basic manager for Core Data. Handles Core Data setup, saving, fetching, and more. It also provides basic support for Core Data iCloud syncing.

What is Core Data? Core Data is a great way to store information in your app. Essentially, Core Data is a database system. Instead of using NSUserDefaults, NSFileManager, or some other wonky storage system for your app's data use Core Data. Xcode provides the interface to layout your Core Data models and SSCoreDataManager provides the interface for using those models.

If you like the project, please [star it](https://github.com/Sam-Spencer/SSCoreDataManager) on GitHub! Watch the project on GitHub for updates. If you use SSCoreDataManager in your app, send an email to contact@iraremedia.com or let me know on Twitter @iRareMedia.

# Table of Contents
- [Project Features](#project-features)
- [Project Information](#project-information)
	- [Requirements](#requirements)
	- [License](#license)
	- [Contributions](#contributions)
	- [Sample App](#sample-app)
- [Documentation](#documentation)
	- [Setup](#setup)
	- [Methods](#methods)
		- [Setup Core Data](#setup-core-data)
		- [Automatically Save Core Data](#automatically-save-core-data)
		- [Insert New Object](#insert-new-object)
		- [Delete Object](#delete-object)
		- [Fetch Objects](#fetch-objects)
	- [Properties](#properties)
	- [Error Delegate](#error-delegate)
	- [iCloud Delegate](#icloud-delegate)

# Project Features
SSCoreDataManager is the best way to get started with basic Core Data storage in your iOS app (may work on OS X, remains untested). Below are a few key project features and highlights.
* Save / Insert, Fetch / Read, Remove, and setup Core Data using one-liners  
* Sync Core Data across devices using iCloud, and with minimal added code
* Easily setup automatic data saving  
* iOS Sample-app to illustrate how easy it is to use SSCoreDataManager  
* Easily contribute to the project  

# Project Information
Learn more about the project requirements, licensing, and contributions.

## Requirements
Requires Xcode 5.0.1 for use in any iOS Project. Requires a minimum of iOS 5.1.1 as the deployment target.  
* Supported build target - iOS 7.0  (Xcode 5.0.1, Apple LLVM compiler 5.0)  
* Earliest supported deployment target - iOS 6.0.0  
* Earliest compatible deployment target - iOS 5.1.1  

Requires iOS 7.0 as the minimum deployment target when using Core Data iCloud syncing. As per Apple's strong recommendation: 

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.

## License 
You are free to make changes and use this in either personal or commercial projects. Attribution is not required, but it appreciated. I have spent a lot of time working on this project - so a little *Thanks!* (or something to that affect) would be much appreciated. If you use SSCoreDataManager in your app, send an email to contact@iraremedia.com or let me know on Twitter @iRareMedia. See the [full SSCoreDataManager license here](https://github.com/Sam-Spencer/SSCoreDataManager/blob/master/LICENSE.md).

## Contributions
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub. Learn more [about contributing to the project here](https://github.com/Sam-Spencer/SSCoreDataManager/blob/master/CONTRIBUTING.md).

## Sample App
The iOS Sample App included with this project demonstrates how to use many of the features in SSCoreDataManagerc. You can refer to the sample app for an understanding of how to use and setup SSCoreDataManager. The app should work with Core Data as-is.

<img width=700 src="https://raw.githubusercontent.com/Sam-Spencer/SSCoreDataManager/master/CoreData%20Screenshot.png"/>

# Documentation
Key methods, properties, types, and delegate methods available in SSCoreDataManager are documented below. If you're using [Xcode 5](https://developer.apple.com/technologies/tools/whats-new.html) with SSCoreDataManager, documentation is available directly within Xcode (just Option-Click any method for Quick Help). Additional Core Data information is coming soon to the Wiki.

## Setup
Adding SSCoreDataManager to your project is easy. Follow these steps below to get everything up and running (this does not include setting up Core Data itself - please see the Wiki for that).
  
  1. Add the SSCoreDataManager class (`SSCoreDataManager.m` & `SSCoreDataManager.h`) to your project
  2. Import `SSCoreDataManager.h`, `#import "SSCoreDataManager.h"`, to your header file(s)
  3. Subscribe to the `<CoreDataManagerDelegate>` delegate.
  4. Setup SSCoreDataManager when your app starts:

        // Set the delegate first, to catch all errors
        [[CoreDataManager sharedManager] setDelegate:self];
        
        // Create and setup your app's Managed Object Context, Persistent Store, and Model (do this before anything else, except for setting the delegate).
        yourController.managedObjectContext = [[CoreDataManager sharedManager] setupDataAndSetSQLiteFileName:@"Your App's SQLite File" andModelFileName:@"XCDataModelD Name"];
        
        // Have SSCoreDataManager automatically save data before your app terminates
        [[CoreDataManager sharedManager] setShouldSaveContextOnAppTermination]; 

## Methods
The most important / highlight methods are documented below. Other forms of these methods with fewer parameters are documented with in-code comments.

### Setup Core Data
Perform any and all necessary setup for Core Data. This includes setting up the Managed Object Context, Model, and  the Persistent Store. Additionally, it will create or initialize your SQLite and Model files. 

If any specific persistent store options (eg. migration) are needed, specify them using the `options` dictionary. You may also set the merge policy which is used to resolve conflicts and automatically merge content (`NSMergeByPropertyObjectTrumpMergePolicy` is recommended).

    - (NSManagedObjectContext *)setupDataAndSetSQLiteFileName:(NSString *)SQLiteName andModelFileName:(NSString *)modelName withPersistentStoreOptions:(NSDictionary *)options andMergePolicy:(id)policy;

To have the persistent store perform an automatic lightweight operation, set the options dictionary like so:

    NSDictionary *options = @{
    			NSMigratePersistentStoresAutomaticallyOption : @YES,
    			NSInferMappingModelAutomaticallyOption : @YES
    };
    
To have the persistent store sync with iCloud use the method below. You may also, optionally, create your own options dictionary (for more flexibility) using any of the [documented `NSPersistentStoreCoordinator` keys](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/CoreDataFramework/Classes/NSPersistentStoreCoordinator_Class/NSPersistentStoreCoordinator.html#//apple_ref/doc/uid/TP30001180-SW3).

    NSDictionary *options = [[SSCoreDataManager sharedManager] recommendedUbiquitousPersistentStoreOptionsForName:@"MyStoreName"];
    
### Automatically Save Core Data
To automatically have your managed object context saved when your app enters the background or before it terminates (recommended), use the following methods:

    - (void)setShouldSaveContextOnAppTermination;
    - (void)setShouldSaveContextOnAppBackgrounding;

### Insert New Object
Create a new managed object from the Core Data Model, and the specified entity. The entity name should be the same as the class name specified in the model. This method will return an `NSManagedObject`. You should already have a managed object in your project which directly correlates to your entity. See the sample project or wiki for more on that.

    - (id)insertObjectForEntityWithName:(NSString *)entityName;

### Delete Object
Delete a managed object from the Core Data Model. The specified `NSManagedObject` should match (exactly) an existing entity.

    - (void)deleteObject:(NSManagedObject *)object;

### Fetch Objects
SSCoreDataManager provides a multitude of methods to fetch core data entities with. However, there are really just two main fetch methods. 

The first fetch method will retrieve a sorted array of all matching entities. The sort attribute should be the name of one of the entity's attributes. SSCoreDataManager will sort the entities (alphabetically or numerically) using this attribute. You may also specify whether or not the sort order is ascending.

    - (NSArray *)fetchEntityWithName:(NSString *)entityName withSortAttribute:(NSString *)sortAttribute ascending:(BOOL)order;

The second fetch method will retrieve a sorted array of all matching entities, and then filter the entities based upon a predicate. There is little difference between this method and the one above. 

    - (NSArray *)fetchEntityWithName:(NSString *)entityName andPredicateFilter:(NSPredicate *)predicate withSortAttribute:(NSString *)sortAttribute ascending:(BOOL)order;

See below for an example of a possible `NSPredicate` for this mehod.

    NSPredicate *samplePredicate = [NSPredicate predicateWithFormat:@"attributeName == %@", self.managedObject.attributeValue];
    
## Properties
SSCoreDataManager provides read-only access to the `NSManagedObjectContext`, `NSManagedObjectModel`, and `NSPersistentStoreCoordinator`. You also have read-write access to the `delegate` property.

## Error Delegate
SSCoreDataManager provides a protocol, `CoreDataManagerDelegate`, which you can use to recieve error information. You can recieve error information by implementing the following method:

    - (void)coreDataManager:(CoreDataManager *)manager errorDidOccur:(NSError *)error;

Refer to the `kCoreDataManagerErrors` for possible known errors and the related error codes. Set the delegate by calling `setDelegate:`.

## iCloud Delegate
Syncing Core Data via iCloud is easy. After setting the [correct parameters](#setup-core-data) and enabling iCloud for your app, SSCoreDataManager will send cloud updates to the `SSUbiquitousCoreDataManagerDelegate`. Set the delegate by calling `setCloudDelegate:`.

There are two required methods on the iCloud protocol. You must implement these methods in order to properly update an local data source or app interface necessary. The first method is called when the persistent store is about to change, and after SSCoreDataManager has merged and saved any other changes.

    - (void)coreDataManagerStoresWillChange:(SSCoreDataManager *)manager;

The second method is called after the persistent store is updated. Both of these methods should be used to update any data source or interface as needed.

    - (void)coreDataManagerStoresDidChange:(SSCoreDataManager *)manager;

To be notified when the persistent store imports content changes, implement the following optional delegate method.

    - (void)coreDataManager:(SSCoreDataManager *)manager persistentStoreDidImportUbiquitousContentChanges:(NSManagedObjectContext *)context;
