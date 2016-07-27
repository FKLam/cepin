//
//  ResumeCompanyNatureVM.m
//  cepin
//
//  Created by dujincai on 15/8/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyNatureVM.h"
#import "BaseCodeDTO.h"
@implementation ResumeCompanyNatureVM
- (instancetype)initWithSelected:(NSString *)selected
{
    self = [super init];
    if (self) {
        self.datas = [BaseCode companyNature];
        self.selection = [BaseCode baseWithCodeKey:selected];
    }
    return self;
}
@end
