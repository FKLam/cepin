//
//  ResumeCompanyJobNameVM.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyJobNameVM.h"
#import "BaseCodeDTO.h"
@implementation ResumeCompanyJobNameVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.opened = NO;
        self.JobFirstData = [BaseCode jobFunction];
    }
    return self;
}
@end
