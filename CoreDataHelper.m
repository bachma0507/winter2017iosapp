//
//  CoreDataHelper.m
//  Winter2016IOSApp
//
//  Created by Barry on 11/14/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

@synthesize json, cscheduleArray, sessionsArray;

#define debug 1

#pragma mark - FILES
//NSString *storeFilename = @"bicsi.sqlite";
NSString *storeFilename = @"group.org.bicsi.winter2017appnew";

#pragma mark - PATHS
- (NSString *)applicationDocumentsDirectory {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class,NSStringFromSelector(_cmd));
    }
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}

- (NSURL *)applicationStoresDirectory {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSURL *storesDirectory =
    [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]
     URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {
            if (debug==1) {
                NSLog(@"Successfully created Stores directory");}
        }
        else {NSLog(@"FAILED to create Stores directory: %@", error);}
    }
    return storesDirectory;
}

- (NSURL *)storeURL {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self applicationStoresDirectory]
            URLByAppendingPathComponent:storeFilename];
}

#pragma mark - SETUP
- (id)init {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self = [super init];
    if (!self) {return nil;}
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc]
                    initWithManagedObjectModel:_model];
    _context = [[NSManagedObjectContext alloc]
                initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    return self;
}

- (void)loadStore {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (_store) {return;} // Don't load store if it's already loaded
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:nil error:&error];
    if (!_store) {NSLog(@"Failed to add store. Error: %@", error);abort();}
    else         {if (debug==1) {NSLog(@"Successfully added store: %@", _store);}
    }
    
    
}

- (void)setupCoreData {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self loadStore];
}

//- (void)setupUpdateData {
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
//    [self updateData];
//}
//
//- (void)setupSessionData {
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
//    [self updateSessions];
//}

#pragma mark - SAVING
- (void)saveContext {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
        } else {
            NSLog(@"Failed to save _context: %@", error);
        }
    } else {
        NSLog(@"SKIPPED _context save, there are no changes!");
    }
}

#pragma mark - SHARED HELPER
+ (CoreDataHelper*)sharedHelper {
    
    static dispatch_once_t predicate;
    static CoreDataHelper *cdh = nil;
    dispatch_once(&predicate, ^{
        cdh = [CoreDataHelper new];
        [cdh setupCoreData];
    });
    return cdh;
}

//-getResults: (NSArray *)myResults {
//
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cschedule" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
//
//    [fetchRequest setEntity:entity];
//
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"trueDate" ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
//
//    [fetchRequest setSortDescriptors:sortDescriptors];
//
//    myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
//
//    return myResults;
//
//}
//
//-(void)updateData{
//
//    //FETCH AND DELETE CSCHEDULE OBJECTS
//#pragma mark - Fetch and Delete CSchedule Objects
//    NSManagedObjectContext *contextCschedule = [[CoreDataHelper sharedHelper] context];
//
//    NSFetchRequest *fetchRequestCschedule = [[NSFetchRequest alloc] init];
//
//    NSEntityDescription *entityCschedule = [NSEntityDescription entityForName:@"Cschedule" inManagedObjectContext:contextCschedule];
//
//    [fetchRequestCschedule setEntity:entityCschedule];
//
//    NSArray *myResultsCschedule = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequestCschedule error:nil];
//    self.objectsSchedule = myResultsCschedule;
//    if (!myResultsCschedule || !myResultsCschedule.count){
//        NSLog(@"No CSchedule objects found to be deleted!");
//    }
//    else{
//        for (NSManagedObject *managedObject in myResultsCschedule) {
//            [contextCschedule deleteObject:managedObject];
//
//            NSError *error = nil;
//            // Save the object to persistent store
//            if (![contextCschedule save:&error]) {
//                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//            }
//            NSLog(@"CSchedule object deleted!");
//
//        }
//    }
//
//    //    //-------------------------
//
//    //CREATE CSCHEDULE OBJECTS
//#pragma mark - Create CSchedule Objects
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//
//        NSURL *url = [NSURL URLWithString:@"https://speedyreference.com/cscheduleC16.php"];
//        NSData * data = [NSData dataWithContentsOfURL:url];
//        NSError * error;
//        //added code 092715 to handle exception
//        if ([data length] == 0 && error == nil)
//        {
//            NSLog(@"No response from server");
//        }
//        else if (error != nil && error.code == NSURLErrorTimedOut)
//        {
//            NSLog(@"Request time out");
//        }
//        else if (error != nil)
//        {
//            NSLog(@"Unexpected error occur: %@", error.localizedDescription);
//        }
//        // response of the server without error will be handled here
//        else if ([data length] > 0 && error == nil)
//        {
//            //end of added code 092715
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//
//                //Set up our cschedule array
//                cscheduleArray = [[NSMutableArray alloc] init];
//
//                for (int i = 0; i < json.count; i++) {
//                    //create cschedule object
//                    NSString * sID = [[json objectAtIndex:i] objectForKey:@"id"];
//                    NSString * sDate = [[json objectAtIndex:i] objectForKey:@"date"];
//                    NSString * sDay = [[json objectAtIndex:i] objectForKey:@"day"];
//                    NSString * sTrueDate = [[json objectAtIndex:i] objectForKey:@"trueDate"];
//
//
//                    CscheduleWatch * myCschedule = [[CscheduleWatch alloc] initWithID: sID andDate: sDate andDay: sDay andTrueDate: sTrueDate];
//
//
//                    //Add our exhibitors object to our exhibitorsArray
//                    [cscheduleArray addObject:myCschedule];
//
//                    NSLog(@"Schedule array count: %lu", (unsigned long)cscheduleArray.count);
//
//                    NSManagedObjectContext *context = [[CoreDataHelper sharedHelper] context];
//
//                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//
//                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cschedule" inManagedObjectContext:context];
//
//                    [fetchRequest setEntity:entity];
//
//                    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@",myCschedule.ID]];
//
//                    NSArray *myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
//
//                    self.objectsSchedule = myResults;
//                    //NSLog(@"SCHEDULE MYRESULTS COUNT = %lu", (unsigned long)myResults.count);
//
//                    if (!myResults || !myResults.count){
//
//                        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Cschedule" inManagedObjectContext:context];
//
//                        [newManagedObject setValue:myCschedule.ID forKey:@"id"];
//
//                        [newManagedObject setValue:myCschedule.day forKey:@"day"];
//
//                        [newManagedObject setValue:myCschedule.date forKey:@"date"];
//
//                        NSDateFormatter *df = [[NSDateFormatter alloc] init];
//                        [df setDateFormat:@"MMM dd yyyy"];
//                        NSDate *csDate = [df dateFromString: myCschedule.trueDate];
//                        [newManagedObject setValue:csDate forKey:@"trueDate"];
//
//
//
//                        NSError *error = nil;
//                        // Save the object to persistent store
//                        if (![context save:&error]) {
//                            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//                        }
//                        NSLog(@"You created a new Cschedule object!");
//                    }
//
//
//                }
//
//
//
//            });
//        }
//    });
//
//
//}

//-(void)updateSessions{
//
//    //---------------------------------
//
//    //FETCH AND DELETE SESSION OBJECTS
//#pragma mark - Fetch and Delete Session Objects
//    NSManagedObjectContext *contextSessions = [[CoreDataHelper sharedHelper] context];
//
//    NSFetchRequest *fetchRequestSessions = [[NSFetchRequest alloc] init];
//
//    NSEntityDescription *entitySessions = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:contextSessions];
//
//    [fetchRequestSessions setEntity:entitySessions];
//
//    NSArray *myResultsSessions = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequestSessions error:nil];
//    self.objectsSession = myResultsSessions;
//    if (!myResultsSessions || !myResultsSessions.count){
//        NSLog(@"No Session objects found to be deleted!");
//    }
//    else{
//        for (NSManagedObject *managedObject in myResultsSessions) {
//            if (![[managedObject valueForKey:@"planner"] isEqualToString:@"Yes"]) {
//
//
//                [contextSessions deleteObject:managedObject];
//
//
//                NSError *error = nil;
//                // Save the object to persistent store
//                if (![contextSessions save:&error]) {
//                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//                }
//                NSLog(@"Session object deleted!");
//
//            }
//        }
//    }
//
//
//    //CREATE SESSION OBJECTS
//#pragma mark - Create Session Objects
//
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//
//
//        NSURL *url = [NSURL URLWithString:@"https://webservice.bicsi.org/json/reply/MobSession?SessionAltCd=CN-WINTER-FL-0117"];
//
//
//
//
//        NSData * data = [NSData dataWithContentsOfURL:url];
//
//
//        //TRUNCATE FRONT AND END OF JSON. ALSO JSON STATEMENT AND CHANGE SESSIONDATE DATE FORMAT
//        NSString * dataStr = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
//        NSString *newDataStr = [dataStr substringWithRange:NSMakeRange(13, [dataStr length]-13)];
//        NSString *truncDataStr = [newDataStr substringToIndex:[ newDataStr length]-1 ];
//
//
//        NSData* truncData = [truncDataStr dataUsingEncoding:NSUTF8StringEncoding];
//        ///////////////
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//
//            //USE STATEMENT BELOW FOR JSON TRUNCATE
//            json = [NSJSONSerialization JSONObjectWithData:truncData options:kNilOptions error:nil];
//
//
//            //Set up our sessions array
//            sessionsArray = [[NSMutableArray alloc] init];
//
//            for (int i = 0; i < json.count; i++) {
//                //create sessions object
//
//                NSString * sName = [[json objectAtIndex:i] objectForKey:@"functiontitle"];
//                NSString * sDate = [[json objectAtIndex:i] objectForKey:@"fucntioindate"];
//                NSString * sSpeaker1 = [[json objectAtIndex:i] objectForKey:@"trainer1firstname"];
//                NSString * sSpeaker1Company = [[json objectAtIndex:i] objectForKey:@"trainer1org"];
//                NSString * sSpeaker2 = [[json objectAtIndex:i] objectForKey:@"trainer2firstname"];
//                NSString * sSpeaker2Company = [[json objectAtIndex:i] objectForKey:@"trainer2org"];
//                NSString * sSpeaker3 = [[json objectAtIndex:i] objectForKey:@"trainer3firstname"];
//                NSString * sSpeaker3Company = [[json objectAtIndex:i] objectForKey:@"trainer3org"];
//                NSString * sSpeaker4 = [[json objectAtIndex:i] objectForKey:@"trainer4firstname"];
//                NSString * sSpeaker4Company = [[json objectAtIndex:i] objectForKey:@"trainer4org"];
//                NSString * sSpeaker5 = [[json objectAtIndex:i] objectForKey:@"trainer5firstname"];
//                NSString * sSpeaker5Company = [[json objectAtIndex:i] objectForKey:@"trainer5org"];
//                NSString * sSpeaker6 = [[json objectAtIndex:i] objectForKey:@"trainer6firstname"];
//                NSString * sSpeaker6Company = [[json objectAtIndex:i] objectForKey:@"trainer6org"];
//                NSString * sDesc = [[json objectAtIndex:i] objectForKey:@"functiondescription"];
//                NSString * sSessionID = [[json objectAtIndex:i] objectForKey:@"FUNCTIONCD"];
//                NSString * sStartTime = [[json objectAtIndex:i] objectForKey:@"functionStartTime"];
//                NSString * sEndTime = [[json objectAtIndex:i] objectForKey:@"functionEndTime"];
//                NSString * sLocation = [[json objectAtIndex:i] objectForKey:@"LOCATIONNAME"];
//                NSString * sSpeaker1lastname = [[json objectAtIndex:i] objectForKey:@"trainer1lastname"];
//                NSString * sSpeaker2lastname = [[json objectAtIndex:i] objectForKey:@"trainer2lastname"];
//                NSString * sSpeaker3lastname = [[json objectAtIndex:i] objectForKey:@"trainer3lastname"];
//                NSString * sSpeaker4lastname = [[json objectAtIndex:i] objectForKey:@"trainer4lastname"];
//                NSString * sSpeaker5lastname = [[json objectAtIndex:i] objectForKey:@"trainer5lastname"];
//                NSString * sSpeaker6lastname = [[json objectAtIndex:i] objectForKey:@"trainer6lastname"];
//
//
//
//                SessionsWatch * mySessions = [[SessionsWatch alloc] initWithSessionDate:sDate andSessionName:sName andSessionSpeaker1:sSpeaker1 andSpeaker1Company:sSpeaker1Company andSessionSpeaker2:sSpeaker2 andSpeaker2Company:sSpeaker2Company andSessionSpeaker3:sSpeaker3 andSpeaker3Company:sSpeaker3Company andSessionSpeaker4:sSpeaker4 andSpeaker4Company:sSpeaker4Company andSessionSpeaker5:sSpeaker5 andSpeaker5Company:sSpeaker5Company andSessionSpeaker6:sSpeaker6 andSpeaker6Company:sSpeaker6Company andSessionDesc:sDesc andSessionID:sSessionID andStartTime:sStartTime andEndTime:sEndTime andLocation:sLocation andSessionSpeaker1lastname:sSpeaker1lastname andSessionSpeaker2lastname:sSpeaker2lastname andSessionSpeaker3lastname:sSpeaker3lastname andSessionSpeaker4lastname:sSpeaker4lastname andSessionSpeaker5lastname:sSpeaker5lastname andSessionSpeaker6lastname:sSpeaker6lastname];
//
//                //Add our sessions object to our sessionsArray
//                [sessionsArray addObject:mySessions];
//                NSLog(@"Sessions array count: %lu", (unsigned long)sessionsArray.count);
//
//                NSManagedObjectContext *context = [[CoreDataHelper sharedHelper] context];
//
//                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//
//                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:context];
//
//                [fetchRequest setEntity:entity];
//
//                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sessionID == %@",mySessions.sessionID]];
//
//                NSArray *myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
//
//                self.objectsSession = myResults;
//
//                //NSLog(@"SESSION MYRESULTS COUNT = %lu", myResults.count);
//
//                if (myResults.count >= 1) {
//                    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
//
//                    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:context];
//                    [fetchRequest2 setEntity:entity2];
//
//                    [fetchRequest2 setPredicate:[NSPredicate predicateWithFormat:@"sessionID == %@", mySessions.sessionID]];
//                    NSArray *results2 = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest2 error:nil];
//
//                    self.objectsSession = results2;
//
//                    NSManagedObject *object = [results2 objectAtIndex:0];
//
//                    NSDateFormatter *dft = [[NSDateFormatter alloc] init];
//
//                    //USE STATEMENT BELOW WHEN USING JSON TRUNCATE
//                    [dft setDateFormat:@"MM-dd-yyyy"];
//
//                    //[dft setDateFormat:@"MM/dd/yyyy hh:mm"];
//                    NSDate *stDate = [dft dateFromString: mySessions.sessionDate];
//                    [object setValue:stDate forKey:@"sessionDate"];
//                    [object setValue:mySessions.sessionSpeaker1 forKey:@"sessionSpeaker1"];
//                    [object setValue:mySessions.sessionSpeaker2 forKey:@"sessionSpeaker2"];
//                    [object setValue:mySessions.sessionSpeaker3 forKey:@"sessionSpeaker3"];
//                    [object setValue:mySessions.sessionSpeaker4 forKey:@"sessionSpeaker4"];
//                    [object setValue:mySessions.sessionSpeaker5 forKey:@"sessionSpeaker5"];
//                    [object setValue:mySessions.sessionSpeaker6 forKey:@"sessionSpeaker6"];
//                    [object setValue:mySessions.speaker1Company forKey:@"speaker1Company"];
//                    [object setValue:mySessions.speaker2Company forKey:@"speaker2Company"];
//                    [object setValue:mySessions.speaker3Company forKey:@"speaker3Company"];
//                    [object setValue:mySessions.speaker4Company forKey:@"speaker4Company"];
//                    [object setValue:mySessions.speaker5Company forKey:@"speaker5Company"];
//                    [object setValue:mySessions.speaker6Company forKey:@"speaker6Company"];
//                    [object setValue:mySessions.sessionSpeaker1lastname forKey:@"sessionSpeaker1lastname"];
//                    [object setValue:mySessions.sessionSpeaker2lastname forKey:@"sessionSpeaker2lastname"];
//                    [object setValue:mySessions.sessionSpeaker3lastname forKey:@"sessionSpeaker3lastname"];
//                    [object setValue:mySessions.sessionSpeaker4lastname forKey:@"sessionSpeaker4lastname"];
//                    [object setValue:mySessions.sessionSpeaker5lastname forKey:@"sessionSpeaker5lastname"];
//                    [object setValue:mySessions.sessionSpeaker6lastname forKey:@"sessionSpeaker6lastname"];
//                    [object setValue:mySessions.sessionDesc forKey:@"sessionDesc"];
//                    [object setValue:mySessions.sessionID forKey:@"sessionID"];
//
//
//                    //[object setValue:[NSDate date:mySessions.startTime] forKey:@"startTime"];
//                    //[object setValue:[NSDate convertTimeFromStr:mySessions.endTime] forKey:@"endTime"];
//
//                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//                    [df setDateFormat:@"hh:mm a"];
//                    NSDate *startTime = [df dateFromString: mySessions.startTime];
//                    [object setValue:startTime forKey:@"startTime"];
//
//                    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
//                    [df2 setDateFormat:@"hh:mm a"];
//                    NSDate *endTime = [df dateFromString: mySessions.endTime];
//                    [object setValue:endTime forKey:@"endTime"];
//
//                    NSString * myLocation3 = [[NSString alloc] initWithFormat:@"%@",mySessions.location];
//                    [object setValue:myLocation3 forKey:@"location"];
//
//                    NSError *error = nil;
//                    // Save the object to persistent store
//                    if (![context save:&error]) {
//                        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//
//                    }
//                    NSLog(@"You updated an object in Sessions");
//                }
//
//                if (!myResults || !myResults.count){
//
//                    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Sessions" inManagedObjectContext:context];
//
//                    [newManagedObject setValue:mySessions.sessionName forKey:@"sessionName"];
//                    //[newManagedObject setValue:mySessions.sessionDay forKey:@"sessionDay"];
//                    //[newManagedObject setValue:mySessions.sessionDate forKey:@"sessionDate"];
//                    NSDateFormatter *dft = [[NSDateFormatter alloc] init];
//
//                    //USE STATEMENT BELOW WHEN USING JSON TRUNCATE
//                    //[dft setDateFormat:@"MM-dd-yyyy"];
//
//                    //[dft setDateFormat:@"MM/dd/yyyy hh:mm"];
//                    [dft setDateFormat:@"MM-dd-yyyy"];
//                    NSDate *stDate = [dft dateFromString: mySessions.sessionDate];
//                    [newManagedObject setValue:stDate forKey:@"sessionDate"];
//
//                    //                        NSDateFormatter *dfy = [[NSDateFormatter alloc] init];
//                    //                        [dfy setDateFormat:@"MMM d yyyy"];
//                    //                        NSDate *sessDate = [dfy dateFromString: mySessions.sessionDate];
//                    //                        [newManagedObject setValue:sessDate forKey:@"sessionDate"];
//
//
//                    [newManagedObject setValue:mySessions.sessionSpeaker1 forKey:@"sessionSpeaker1"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker2 forKey:@"sessionSpeaker2"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker3 forKey:@"sessionSpeaker3"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker4 forKey:@"sessionSpeaker4"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker5 forKey:@"sessionSpeaker5"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker6 forKey:@"sessionSpeaker6"];
//                    [newManagedObject setValue:mySessions.speaker1Company forKey:@"speaker1Company"];
//                    [newManagedObject setValue:mySessions.speaker2Company forKey:@"speaker2Company"];
//                    [newManagedObject setValue:mySessions.speaker3Company forKey:@"speaker3Company"];
//                    [newManagedObject setValue:mySessions.speaker4Company forKey:@"speaker4Company"];
//                    [newManagedObject setValue:mySessions.speaker5Company forKey:@"speaker5Company"];
//                    [newManagedObject setValue:mySessions.speaker6Company forKey:@"speaker6Company"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker1lastname forKey:@"sessionSpeaker1lastname"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker2lastname forKey:@"sessionSpeaker2lastname"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker3lastname forKey:@"sessionSpeaker3lastname"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker4lastname forKey:@"sessionSpeaker4lastname"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker5lastname forKey:@"sessionSpeaker5lastname"];
//                    [newManagedObject setValue:mySessions.sessionSpeaker6lastname forKey:@"sessionSpeaker6lastname"];
//
//
//                    [newManagedObject setValue:mySessions.sessionDesc forKey:@"sessionDesc"];
//                    [newManagedObject setValue:mySessions.sessionID forKey:@"sessionID"];
//                    //[newManagedObject setValue:mySessions.startTime forKey:@"startTime"];
//
//                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//
//                    [df setDateFormat:@"hh:mm a"];
//                    NSDate *startTime = [df dateFromString: mySessions.startTime];
//                    [newManagedObject setValue:startTime forKey:@"startTime"];
//
//                    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
//                    [df2 setDateFormat:@"hh:mm a"];
//                    NSDate *endTime = [df dateFromString: mySessions.endTime];
//                    [newManagedObject setValue:endTime forKey:@"endTime"];
//
//                    //[newManagedObject setValue:[NSDate convertTimeFromStr:mySessions.startTime] forKey:@"startTime"];
//                    //[newManagedObject setValue:[NSDate convertTimeFromStr:mySessions.endTime] forKey:@"endTime"];
//
//                    NSString * myLocation3 = [[NSString alloc] initWithFormat:@"%@",mySessions.location];
//                    [newManagedObject setValue:myLocation3 forKey:@"location"];
//
//
//
//
//
//                    NSError *error = nil;
//                    // Save the object to persistent store
//                    if (![context save:&error]) {
//                        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//                    }
//                    NSLog(@"You created a new Session object! Session ID: %@",mySessions.sessionID);
//                    //NSLog(@"Object created sessionName is: %@",mySessions.sessionName);
//                }
//
//
//
//
//            }
//
//
//        });
//
//    });



//}



@end
