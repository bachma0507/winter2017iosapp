//
//  MyScheduleTableRow.h
//  Canada2016IOSAppNew
//
//  Created by Barry on 3/1/16.
//  Copyright © 2016 BICSI. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WatchKit;


@interface MyScheduleTableRow : NSObject
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *session;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *start;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *location;

@end
