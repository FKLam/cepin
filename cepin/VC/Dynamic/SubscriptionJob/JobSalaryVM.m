//
//  JobSalaryVM.m
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobSalaryVM.h"
#import "BaseCodeDTO.h"
@implementation JobSalaryVM
- (instancetype)init
{
    self = [super init];
    if (self ) {
        
        self.datas = @[@"2k以下",@"2k-4k",@"4k-6k",@"6k-8k",@"8k-10k",@"10k-12k",@"12k-15k",@"15k及以上"];
    }
    return self;
}
@end
