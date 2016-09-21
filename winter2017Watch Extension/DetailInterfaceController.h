//
//  DetailInterfaceController.h
//  Canada2016IOSApp
//
//  Created by Barry on 11/18/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"
#import "CscheduleWatch.h"
#import "SessionsWatch.h"

@interface DetailInterfaceController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfaceTable *detailTable;

@property (nonatomic, strong) NSMutableArray * sessionsArray;

@property (nonatomic, strong) NSMutableArray * json;

@property (nonatomic, strong) NSMutableArray * myNewArray;

@property (strong, nonatomic) NSArray *objectsArray;
@property (nonatomic, strong) NSDictionary *objectsTable;
@property (nonatomic, strong) CscheduleWatch * cschedule;

@end
