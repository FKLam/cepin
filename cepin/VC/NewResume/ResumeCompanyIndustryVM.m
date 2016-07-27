//
//  ResumeCompanyIndustryVM.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyIndustryVM.h"
#import "BaseCodeDTO.h"
@implementation ResumeCompanyIndustryVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.opened = NO;
        self.industryData = [NSMutableArray new];
        self.industryData = [BaseCode industry];
    }
    return self;
}

@end
