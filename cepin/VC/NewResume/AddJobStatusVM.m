//
//  AddJobStatusVM.m
//  cepin
//
//  Created by dujincai on 15/6/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddJobStatusVM.h"
#import "RTNetworking+Resume.h"
#import "BaseCodeDTO.h"
@implementation AddJobStatusVM
- (instancetype)initWithResume:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.resumeNameModel = model;
         self.titleArrays = [BaseCode JobStatus];
        for ( NSInteger index = 0; index < [self.titleArrays count]; index++ )
        {
            if ( 1 == index || 2 == index )
                continue;
            [self.jobStatusArrays addObject:self.titleArrays[index]];
        }
    }
    return self;
}
- (NSMutableArray *)jobStatusArrays
{
    if ( !_jobStatusArrays )
    {
        _jobStatusArrays = [NSMutableArray array];
    }
    return _jobStatusArrays;
}
/*
- (void)addJobStatus
{
    TBLoading *load = [TBLoading new];
    [load start];
    
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    
    RACSignal *signal = [[RTNetworking shareInstance]addThridResumeJobStatusWithUserId:userId tokenId:TokenId workStatusCode:[NSString stringWithFormat:@"%@",self.jobNumber]];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.resumeNameModel =[ResumeNameModel beanFormDic:[dic resultObject]];
            
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
        
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        self.stateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
*/
@end
