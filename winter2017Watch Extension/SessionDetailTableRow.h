//
//  SessionDetailTableRow.h
//  Canada2016IOSAppNew
//
//  Created by Barry on 11/23/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WatchKit;

@interface SessionDetailTableRow : NSObject
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *sessionNameLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *sessionDescLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *locationLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *start;

@end
