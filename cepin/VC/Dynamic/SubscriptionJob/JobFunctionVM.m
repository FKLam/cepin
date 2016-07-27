//
//  JobFunctionVM.m
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobFunctionVM.h"
#import "TBTextUnit.h"
@implementation JobFunctionVM
- (instancetype)initWithJobModel:(SubscriptionJobModel *)model
{
    self = [super init];
    if (self) {
        self.functionKeys = model.jobFunctionskey;
        self.functions = model.jobFunctions;
        self.isShrink = NO;
        self.datas = [BaseCode jobFunction];
        self.jobFunctions = [NSMutableArray new];
        self.jobFunctionsKey = [NSMutableArray new];
        
        if ([model.jobFunctions isEqualToString:@""] || !model.jobFunctions) {
            [self.jobFunctions removeAllObjects];
        }
        else
        {
            NSArray *array =  [model.jobFunctions componentsSeparatedByString:@","];
            
            [self.jobFunctions addObjectsFromArray:array];
        }
        
        if ([model.jobFunctionskey isEqualToString:@""] || !model.jobFunctionskey) {
            [self.jobFunctions removeAllObjects];
        }
        else
        {
           self.jobFunctionsKey =[NSMutableArray arrayWithArray:[model.jobFunctionskey componentsSeparatedByString:@","]];
        }
       
      
    }
    return self;
}
@end
