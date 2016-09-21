//
//  ScheduleTableRow.h
//  Canada2016IOSApp
//
//  Created by Barry on 11/16/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WatchKit;

@interface ScheduleTableRow : NSObject
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *name;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *date;

@end
