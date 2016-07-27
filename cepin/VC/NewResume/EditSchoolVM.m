//
//  EditSchoolVM.m
//  cepin
//
//  Created by dujincai on 15/8/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditSchoolVM.h"
#import "SchoolDTO.h"
@implementation EditSchoolVM
- (instancetype)initWithselectedSchool:(NSString *)selectedSchool
{
    if (self = [super init])
    {
        self.schools = [School school];
        self.selectSchool = [School searchSchoolsWithShoolNames:selectedSchool];
    }
    return self;
}
@end
