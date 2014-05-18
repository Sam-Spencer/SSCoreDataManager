//
//  SSMasterViewController.h
//  Data Test
//
//  Created by Sam Spencer on 5/18/14.
//  Copyright (c) 2014 Sam Spencer. All rights reserved.
//

#import "Event.h"

@interface SSMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, SSCoreDataManagerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
