//
//  JobSendResumeSucessVM.m
//  cepin
//
//  Created by dujincai on 15/6/8.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobSendResumeSucessVM.h"
#import "RTNetworking+Position.h"
#import "RTNetworking+DynamicState.h"
#import "JobSearchModel.h"
@implementation JobSendResumeSucessVM
- (instancetype)initWithPositionId:(NSString*)positionId
{
    self = [super init];
    if (self) {
        self.positionId = positionId;
    }
    return self;
}
- (void)allPositionId
{
    self.positionIdArray = [PositionIdModel allPositionIds];
}
- (void)isOpenSpeedExam
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTokenId = @"";
    }
    TBLoading *load = [TBLoading new];
    [load start];
    RACSignal *signal = [[RTNetworking shareInstance]isExamWithTokenId:strTokenId userId:strUser];
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
           self.isExam = [[[dic resultObject]objectForKey:@"IsFinshed"] boolValue];

            self.isExamStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.isExamStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        self.isExamStateCode = error;
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout ];
    }];
}
- (void)getExamList
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
    RACSignal *signal = [[RTNetworking shareInstance] getDynamicStateExamListWithUUID:UUID_KEY tokenId:strTocken userId:strUser PageIndex:self.page PageSize:self.size examStatus:@"1"];
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
                self.examListStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
        }
        else
        {
            self.examListStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        self.stateCode = error;
        RTLog(@"%@",[error description]);
    }];
}
-(void)loadDataWithPage:(NSInteger)page
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance] userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTokenId = @"";
    }
    TBLoading *load = [TBLoading new];
    [load start];
    RACSignal *signal = [[RTNetworking shareInstance] positionSimilarityWithSize:3 positionIds:self.positionId tokenId:strTokenId userId:strUser];
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
//            self.datas = [NSMutableArray arrayWithArray:array];
            [self.datas removeAllObjects];
            [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[JobSearchModel class]];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            [self.datas removeAllObjects];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        }
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        self.stateCode = error;
        //这个地方弹出错误提示，如果当前页面＝＝显示的页面
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout ];
        RTLog(@"%@",[error description]);
    }];
}
@end