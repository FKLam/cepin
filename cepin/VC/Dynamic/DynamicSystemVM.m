//
//  DynamicSystemVM.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicSystemVM.h"
#import "RTNetworking+DynamicState.h"

@implementation DynamicSystemVM

-(void)loadDataWithPage:(NSInteger)page
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTocken = [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTocken = @"";
    }
    
    TBLoading *load = [TBLoading new];
    [load start];
    
    RACSignal *signal = [[RTNetworking shareInstance]getDynamicStateSystemMessageListWithTokenId:strTocken userId:strUser PageIndex:self.page PageSize:self.size];
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
                [self dealDataAndStateCodeWithPage:self.page bean:array];
            }
        }
        else
        {
            [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        self.stateCode = error;
        RTLog(@"%@",[error description]);
    }];
}

@end
