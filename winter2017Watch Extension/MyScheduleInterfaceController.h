//
//  MyScheduleInterfaceController.h
//  Canada2016IOSAppNew
//
//  Created by Barry on 2/29/16.
//  Copyright © 2016 BICSI. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"
#import "CscheduleWatch.h"
#import "SessionsWatch.h"

@interface MyScheduleInterfaceController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfaceTable *myScheduleTable;

@property (nonatomic, strong) NSMutableArray * sessionsArray;

@property (nonatomic, strong) NSMutableArray * json;

@property (nonatomic, strong) NSMutableArray * myNewArray;

@property (strong, nonatomic) NSArray *objectsArray;
@property (nonatomic, strong) NSDictionary *objectsTable;
@property (nonatomic, strong) CscheduleWatch * cschedule;


@end
