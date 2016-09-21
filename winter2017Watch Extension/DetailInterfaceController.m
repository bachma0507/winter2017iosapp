//
//  DetailInterfaceController.m
//  Canada2016IOSApp
//
//  Created by Barry on 11/18/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import "DetailInterfaceController.h"
#import "DetailTableRow.h"


@interface DetailInterfaceController ()


@end

@implementation DetailInterfaceController

@synthesize objectsTable, cschedule, json, sessionsArray, objectsArray, myNewArray;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    
    
    NSString * myDate = context;
    
    NSLog(@"Value for myDate = %@", myDate);
    
    [self setTitle: myDate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
    
    [fetchRequest setEntity:entity];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MMM d yyyy"];
    NSDate *sessDate = [df dateFromString: myDate];
    NSString * strDate = [df stringFromDate:sessDate];
    NSLog(@"Value of strDate = %@", strDate);
    
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT(sessionID CONTAINS 'EXHV' || sessionID CONTAINS 'EXHX' || sessionID CONTAINS 'DRIN' || sessionID CONTAINS 'BADG' || sessionID CONTAINS 'CRED_H' || sessionID CONTAINS 'FTA' || sessionID CONTAINS 'GUES' || sessionID CONTAINS 'NEW_' || sessionID CONTAINS 'GS_TUESA' || sessionID CONTAINS 'GS_TUESP' || sessionID CONTAINS 'GS_THURA' || sessionID CONTAINS 'OD_') && sessionDate == %@",sessDate]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
    
    self.objectsArray = myResults;
    
    NSLog(@"Schedule myResults count: %lu", (unsigned long)myResults.count);
    if (myResults.count == 0) {
        [self pushControllerWithName:@"ErrorInterfaceController"
                             //context:nil];
        //[self presentControllerWithName:@"ErrorInterfaceController"
                             context:nil];
    }
    
    else {
    
    NSLog(@"Sessions myResults count: %lu", (unsigned long)myResults.count);
    NSLog(@"Sessions objectsArray count: %lu", (unsigned long)self.objectsArray.count);
    
    self.myNewArray = [[NSMutableArray alloc] init];
    
    [self.detailTable setNumberOfRows:self.objectsArray.count withRowType:@"DetailTableRow"];
    
    for (int i = 0; i < self.objectsArray.count; i++) {
        DetailTableRow *detailRow = [self.detailTable rowControllerAtIndex:i];
        
        NSManagedObject *item = myResults[i];
        detailRow.session.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"sessionName"]];
        detailRow.location.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"location"]];
        
        NSDate * sTime = [item valueForKey:@"startTime"];
        NSDate * eTime = [item valueForKey:@"endTime"];
        
        
        // set the formatter like this
        NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
        [sdf setDateStyle:NSDateFormatterNoStyle];
        [sdf setTimeStyle:NSDateFormatterShortStyle];
        
        // set the formatter like this
        NSDateFormatter *edf = [[NSDateFormatter alloc] init];
        [edf setDateStyle:NSDateFormatterNoStyle];
        [edf setTimeStyle:NSDateFormatterShortStyle];
        
        
        NSString * startTime = [sdf stringFromDate:sTime];
        NSString * endTime = [sdf stringFromDate:eTime];
        
        detailRow.start.text = startTime;
        detailRow.end.text = endTime;
        
        [self.myNewArray addObject:[item valueForKey:@"SessionID"]];
        
        NSString * sessionIdStr = [NSString stringWithFormat:@"%@",[item valueForKey:@"sessionID"]];
        NSLog(@"SessionID is: %@", sessionIdStr);
        
    }
    }
    
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    // Push detail view with selected quote
    
    NSString * sessionId = [NSString stringWithFormat:@"%@", [self.myNewArray objectAtIndex:rowIndex]];
    
    [self pushControllerWithName:@"SessionDetailInterfaceController" context:sessionId];
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



