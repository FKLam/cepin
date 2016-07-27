//
//  SubscriptionVM.m
//  cepin
//
//  Created by ricky.tang on 14-10-21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SubscriptionJobVM.h"
#import "RTNetworking+DynamicState.h"
#import "RegionDTO.h"
#import "BookingJobFilterModel.h"
#import "TBTextUnit.h"
@implementation SubscriptionJobVM

-(instancetype)initWithSubModel:(SubscriptionJobModel *)model
{
    if (self = [super init])
    {
        NSString *strUser = [[MemoryCacheData shareInstance]userId];
        if (!strUser)
        {
            strUser = @"";
        }
        [[BookingJobFilterModel shareInstance]reloadWithFileName:strUser];
        self.images = @[@"ic_function",@"ic_city",@"ic_pay",@"ic_category",@"ic_yeah",@"filter_ic_type"];
        self.placeholders = @[@"所有职能",@"全国",@"不限",@"不限",@"不限",@"不限"];
        self.titles = @[@"职能类别",@"工作地点",@"期望薪酬",@"工作性质",@"工作年限",@"招聘类型"];
        self.jobModel = [SubscriptionJobModel new];
        
        self.jobModel = model;
    }
    
    return self;
}


@end
