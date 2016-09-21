//
//  CscheduleWatch.m
//  Canada2016IOSApp
//
//  Created by Barry on 11/17/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import "CscheduleWatch.h"

@implementation CscheduleWatch

@synthesize ID, date, day, trueDate;

-(id) initWithID: (NSString *) sID andDate: (NSString *) sDate andDay: (NSString *) sDay andTrueDate: (NSString *) sTrueDate

{
    
    self = [super init];
    if (self) {
        
        ID = sID;
        date = sDate;
        day = sDay;
        trueDate = sTrueDate;
        
    }
    return self;
}


@end
