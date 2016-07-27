//
//  FullExamReportVM.m
//  cepin
//
//  Created by dujincai on 15/7/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullExamReportVM.h"
#import "RTNetworking+DynamicState.h"
@implementation FullExamReportVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datas = [NSMutableArray new];
        
    }
    return self;
}
- (void)getExamReport
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString*tokenId = [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
    }
    
    TBLoading *load = [TBLoading new];
    [load start];
    
    RACSignal *signal = [[RTNetworking shareInstance]getMeExamReportWith:strUser tokenId:tokenId];
    
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        if (load)
        {
            [load stop];
        }
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            RTLog(@"%@",array);
            if (array)
            {
                self.datas = [NSMutableArray arrayWithArray:array];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
        }
        else
        {
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        self.stateCode = error;
        RTLog(@"%@",[error description]);
    }];
}


@end
