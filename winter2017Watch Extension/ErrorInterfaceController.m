//
//  ErrorInterfaceController.m
//  Canada2016IOSAppNew
//
//  Created by Barry on 11/24/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import "ErrorInterfaceController.h"

@interface ErrorInterfaceController ()

@end

@implementation ErrorInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)tryAgain {
    
    [self pushControllerWithName:@"InterfaceController"
                         context:nil];
    //[self presentControllerWithName:@"InterfaceController"
                         //context:nil];
    
    //[self dismissController];
    
    
}
@end



