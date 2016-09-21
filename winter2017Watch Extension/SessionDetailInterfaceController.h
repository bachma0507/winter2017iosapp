//
//  SessionDetailInterfaceController.h
//  Canada2016IOSAppNew
//
//  Created by Barry on 11/22/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"
#import "CscheduleWatch.h"
#import "SessionsWatch.h"

@interface SessionDetailInterfaceController : WKInterfaceController


//@property (nonatomic, strong) NSMutableArray * myNewArray;
@property (strong, nonatomic) IBOutlet WKInterfaceTable *SessionDetailTable;

@property (strong, nonatomic) NSArray *objectsArray;

@end
