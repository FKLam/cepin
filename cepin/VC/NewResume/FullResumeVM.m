//
//  FullResumeVM.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullResumeVM.h"
#import "RTNetworking+Resume.h"
#import "RTNetworking+DynamicState.h"
@interface FullResumeVM ()
@property (nonatomic, strong) TBLoading *loadData;
@end
@implementation FullResumeVM
-(instancetype)initWithResumeId:(NSString *)resumeId
{
    self = [super init];
    if (self) {
        self.resumeId = resumeId;
        self.reportDatas = [NSMutableArray new];
        [self.workYearArrayM addObjectsFromArray:[BaseCode workYears]];
    }
    return self;
}
-(void)getFullResumeDetail
{
    self.loadData = [TBLoading new];
    [self.loadData start];
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    RACSignal *signal = [[RTNetworking shareInstance]getThridResumeDetailWithResumeId:self.resumeId userId:userId tokenId:TokenId];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.data = [ResumeNameModel beanFormDic:[dic resultObject]];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        if (self.loadData)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.loadData stop];
            });
        }
    } error:^(NSError *error){
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
    }];
}
- (void)stop
{
    if (self.loadData)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.loadData stop];
        });
    }
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
}
-(void)toTop
{
    TBLoading *load = [TBLoading new];
    [load start];
    
    RACSignal *signal = [[RTNetworking shareInstance]toTopWithResumeId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId resumeId:self.resumeId];
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
            self.toTopStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            [OMGToast showWithText:NetWorkOprationSuccess topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.toTopStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                self.toTopStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
        
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        self.toTopStateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
-(void)deleteResume
{
    TBLoading *load = [TBLoading new];
    [load start];
    RACSignal *signal = [[RTNetworking shareInstance]deleteWithResumeId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId resumeId:self.resumeId];
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
            self.deleteStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            [OMGToast showWithText:NetWorkOprationSuccess topOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.deleteStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                self.deleteStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
        
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        self.deleteStateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
- (void)getExamReport
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString*tokenId = [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
    }
    RACSignal *signal = [[RTNetworking shareInstance]getMeExamReportWith:strUser tokenId:tokenId];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            if (array)
            {
                self.reportDatas = [NSMutableArray arrayWithArray:array];
                self.reportStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
        }
        else
        {
            self.reportStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } error:^(NSError *error){
        self.reportStateCode = error;
    }];
}
- (NSMutableArray *)workYearArrayM
{
    if ( !_workYearArrayM )
    {
        _workYearArrayM = [NSMutableArray array];
    }
    return _workYearArrayM;
}
@end
