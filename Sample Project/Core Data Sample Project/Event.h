//
//  Event.h
//  Core Data Smaple Project
//
//  Created by Sam Spencer on 5/18/14.
//  Copyright (c) 2014 Sam Spencer. All rights reserved.
//

@interface Event : NSManagedObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *eventID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;

@end
