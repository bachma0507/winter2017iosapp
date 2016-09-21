//
//  SessionDetailInterfaceController.m
//  Canada2016IOSAppNew
//
//  Created by Barry on 11/22/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import "SessionDetailInterfaceController.h"
#import "SessionDetailTableRow.h"

@interface SessionDetailInterfaceController ()

@end

@implementation SessionDetailInterfaceController


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    
    NSString * mySessionId = context;
    
    NSLog(@"Value for mySessionId = %@", mySessionId);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions" inManagedObjectContext:[[CoreDataHelper sharedHelper] context]];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sessionID == %@",mySessionId]];
    
    NSArray *myResults = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:fetchRequest error:nil];
    
    self.objectsArray = myResults;
    
    [self.SessionDetailTable setNumberOfRows:self.objectsArray.count withRowType:@"SessionDetailTableRow"];
    
    for (int i = 0; i < self.objectsArray.count; i++) {
        SessionDetailTableRow *sessionDetailRow = [self.SessionDetailTable rowControllerAtIndex:i];
    
    
    NSManagedObject *item = myResults[i];
    
    sessionDetailRow.sessionNameLabel.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"sessionName"]];
    sessionDetailRow.sessionDescLabel.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"sessionDesc"]];
    sessionDetailRow.locationLabel.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"location"]];
        
    NSDate * sTime = [item valueForKey:@"startTime"];
        
    // set the formatter like this
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    [sdf setDateStyle:NSDateFormatterNoStyle];
    [sdf setTimeStyle:NSDateFormatterShortStyle];
        
    // set the formatter like this
    NSDateFormatter *edf = [[NSDateFormatter alloc] init];
    [edf setDateStyle:NSDateFormatterNoStyle];
    [edf setTimeStyle:NSDateFormatterShortStyle];
        
        
    NSString * startTime = [sdf stringFromDate:sTime];
    
    sessionDetailRow.start.text = startTime;

    
    //NSString * name = [NSString stringWithFormat:@"%@",[self.objectsArray valueForKey:@"sessionName"]];
    //NSString * desc = [NSString stringWithFormat:@"%@",[self.objectsArray valueForKey:@"sessionDesc"]];
    
    //NSLog(@"Value of name is: %@", name);
    //NSLog(@"Value of desc is: %@", desc);
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



