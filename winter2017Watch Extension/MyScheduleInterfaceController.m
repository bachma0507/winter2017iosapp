//
//  MyScheduleInterfaceController.m
//  Canada2016IOSAppNew
//
//  Created by Barry on 2/29/16.
//  Copyright © 2016 BICSI. All rights reserved.
//

#import "MyScheduleInterfaceController.h"
#import "MyScheduleTableRow.h"

@interface MyScheduleInterfaceController ()

@end

@implementation MyScheduleInterfaceController

@synthesize objectsTable, cschedule, json, sessionsArray, objectsArray, myNewArray;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self mySchedule];
    
//    NSString * mySched = context;
//    
//    NSLog(@"Value for mySched = %@", mySched);
//    
//    [self setTitle: mySched];

    
    // Configure interface objects here.
    
}

- (void) mySchedule{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
    
    [fetchRequest setEntity:entity];
    
    
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT(sessionID CONTAINS 'GUES' || sessionID CONTAINS 'OD_') && agenda == 'Yes'"]];
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"planner == 'Yes'"]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"planner == 'Yes'"]];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sessionDate" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
    
    self.objectsArray = myResults;
    
    NSLog(@"Schedule myResults count: %lu", (unsigned long)myResults.count);
    if (myResults.count == 0) {
        [self pushControllerWithName:@"ErrorInterfaceController"
                             context:nil];
    }
    
    else {
        
        NSLog(@"Sessions myResults count: %lu", (unsigned long)myResults.count);
        NSLog(@"Sessions objectsArray count: %lu", (unsigned long)self.objectsArray.count);
        
        self.myNewArray = [[NSMutableArray alloc] init];
        
        [self.myScheduleTable setNumberOfRows:self.objectsArray.count withRowType:@"MyScheduleTableRow"];
        
        for (int i = 0; i < self.objectsArray.count; i++) {
            MyScheduleTableRow *myScheduleRow = [self.myScheduleTable rowControllerAtIndex:i];
            
            NSManagedObject *item = myResults[i];
            myScheduleRow.session.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"sessionName"]];
            myScheduleRow.location.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"location"]];
            
            NSDate * sTime = [item valueForKey:@"startTime"];
            //NSDate * eTime = [item valueForKey:@"endTime"];
            
            
            // set the formatter like this
            NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
            [sdf setDateStyle:NSDateFormatterNoStyle];
            [sdf setTimeStyle:NSDateFormatterShortStyle];
            
            // set the formatter like this
            //NSDateFormatter *edf = [[NSDateFormatter alloc] init];
            //[edf setDateStyle:NSDateFormatterNoStyle];
            //[edf setTimeStyle:NSDateFormatterShortStyle];
            
            
            NSString * startTime = [sdf stringFromDate:sTime];
            //NSString * endTime = [sdf stringFromDate:eTime];
            
            myScheduleRow.start.text = startTime;
            //myScheduleRow.end.text = endTime;
            
            [self.myNewArray addObject:[item valueForKey:@"SessionID"]];
            
            NSString * sessionIdStr = [NSString stringWithFormat:@"%@",[item valueForKey:@"sessionID"]];
            NSLog(@"SessionID is: %@", sessionIdStr);
            
        }
    }
    
    
    

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



