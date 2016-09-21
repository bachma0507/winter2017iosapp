//
//  CscheduleWatch.h
//  Canada2016IOSApp
//
//  Created by Barry on 11/17/15.
//  Copyright © 2015 BICSI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CscheduleWatch : NSObject

@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * day;
@property (nonatomic, strong) NSString * trueDate;


//methods
-(id) initWithID: (NSString *) sID andDate: (NSString *) sDate andDay: (NSString *) sDay andTrueDate: (NSString *) sTrueDate;

@end
