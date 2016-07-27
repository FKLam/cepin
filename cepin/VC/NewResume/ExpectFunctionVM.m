//
//  ExpectFunctionVM.m
//  cepin
//
//  Created by dujincai on 15/6/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExpectFunctionVM.h"
#import "BaseCodeDTO.h"
#import "TBTextUnit.h"
@implementation ExpectFunctionVM
-(instancetype)initWithResumeModel:(ResumeNameModel*)model
{
    if (self = [super init]) {
        self.resumeJobFunction = model.ExpectJobFunction;
        self.isShrink = NO;
        self.datas = [BaseCode jobFunction];
        self.jobFunctions = [NSMutableArray new];

        if ([model.ExpectJobFunction isEqualToString:@""] || !model.ExpectJobFunction) {
            [self.jobFunctions removeAllObjects];
        }
        else
        {
            self.jobFunctions = [NSMutableArray arrayWithArray:[model.ExpectJobFunction componentsSeparatedByString:@","]];
        }
    }
    return self;
}
@end
