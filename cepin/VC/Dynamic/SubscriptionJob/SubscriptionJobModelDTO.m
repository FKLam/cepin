//
//  SubscriptionJobModelDTO.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SubscriptionJobModelDTO.h"
#import "BookingJobFilterModel.h"
#import "TBTextUnit.h"

@implementation SendSubscriptionJobModelDTO

-(instancetype)init
{
    if (self = [super init])
    {
        self.UUID = UUID_KEY;
        self.userId = @"";
        self.tokenId = @"";
        self.address = [TBTextUnit allRegionPathCodeWithRegions:[[BookingJobFilterModel shareInstance] addresses]];
        self.jobPropertys = [[BookingJobFilterModel shareInstance]jobProperty].PathCode?[[BookingJobFilterModel shareInstance]jobProperty].PathCode:@"";
        self.salary = [[BookingJobFilterModel shareInstance]salary].PathCode?[[BookingJobFilterModel shareInstance]salary].PathCode:@"";
        self.jobFunctions = [TBTextUnit allCodeKeyWithBaseCodeArray:[[BookingJobFilterModel shareInstance]jobFunctions]];
        self.industries = [TBTextUnit allCodeKeyWithBaseCodeArray:[[BookingJobFilterModel shareInstance]industries]];
        self.companyNature = [TBTextUnit allCodeKeyWithBaseCodeArray:[[BookingJobFilterModel shareInstance]companyNature]];
        self.companySize = [TBTextUnit allCodeKeyWithBaseCodeArray:[[BookingJobFilterModel shareInstance]companySize]];
        return self;
    }
    return nil;
}

-(void)clearAll
{
    self.address = @"";
    self.jobPropertys = @"";
    self.salary = @"";
    self.jobFunctions = @"";
    self.industries = @"";
    self.companyNature = @"";
    self.companySize = @"";
}

-(void)clearSearch
{
    self.address = @"";
    self.jobPropertys = @"";
    self.salary = @"";
}

@end


@implementation SubscriptionJobModelDTO

@end



