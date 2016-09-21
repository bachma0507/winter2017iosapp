//
//  InterfaceController.h
//  canada2016Watch Extension
//
//  Created by Barry on 11/16/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"
#import "CscheduleWatch.h"
#import "SessionsWatch.h"

@interface InterfaceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceTable *table;
@property (strong, nonatomic) NSArray *objectsTable;

@property (strong, nonatomic) NSArray *objectsSchedule;
@property (strong, nonatomic) NSArray *objectsSession;

@property (nonatomic, strong) NSMutableArray * json;

@property (nonatomic, strong) NSMutableArray * myNewArray;

@property (nonatomic, strong) NSMutableArray * cscheduleArray;

@property (nonatomic, strong) NSMutableArray * sessionsArray;

@property (strong, nonatomic) IBOutlet WKInterfaceButton *myScheduleButton;

- (IBAction)mySchedButtonPressed;


@end
