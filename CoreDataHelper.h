//
//  CoreDataHelper.h
//  Winter2016IOSApp
//
//  Created by Barry on 11/14/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SessionsWatch.h"
#import "CscheduleWatch.h"

@interface CoreDataHelper :NSObject

@property (nonatomic, readonly) NSManagedObjectContext       *context;
@property (nonatomic, readonly) NSManagedObjectModel         *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore            *store;

@property (strong, nonatomic) NSArray *objectsSchedule;
@property (strong, nonatomic) NSArray *objectsSession;

@property (nonatomic, strong) NSMutableArray * json;

@property (nonatomic, strong) NSMutableArray * cscheduleArray;

@property (nonatomic, strong) NSMutableArray * sessionsArray;

+ (CoreDataHelper*)sharedHelper;

- (void)setupCoreData;
- (void)saveContext;
//- getResults: (NSArray *)myResults;

@end
