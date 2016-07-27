//
//  SubscriptionJobModel.m
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SubscriptionJobModel.h"

@implementation SubscriptionJobModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config
{
    self.jobFunctions = @"";
    self.jobFunctionskey = @"";
    self.jobPropertys = @"";
    self.jobPropertyskey = @"";
    self.salarykey = @"";
    self.salary = @"";
    self.workYear = @"";
    self.workYearkey = @"";
    self.address = @"";
    self.addresskey = @"";
    self.positionType = @"";
    self.positionTypekey = @"";
    self.workYearMin = @"";
    self.workYearMax = @"";
}
@end
