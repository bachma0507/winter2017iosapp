//
//  DetailTableRow.h
//  Canada2016IOSApp
//
//  Created by Barry on 11/18/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WatchKit;

@interface DetailTableRow : NSObject
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *session;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *start;

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *end;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *location;


@end
