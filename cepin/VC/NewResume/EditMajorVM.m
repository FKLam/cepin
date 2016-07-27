//
//  EditMajorVM.m
//  cepin
//
//  Created by dujincai on 15/8/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditMajorVM.h"
#import "BaseCodeDTO.h"
@implementation EditMajorVM
- (instancetype)initWithselectedMajor:(NSString *)selectedmajor
{
    if (self = [super init])
    {
        self.majors = [BaseCode AllMajor];
        self.selectMajor = [BaseCode DegreeWithFullName:selectedmajor];
        
    }
    return self;
}
@end
