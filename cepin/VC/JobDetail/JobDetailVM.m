//
//  JobDetailVM.m
//  cepin
//
//  Created by ricky.tang on 14-10-31.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobDetailVM.h"
#import "RTNetworking+Position.h"
#import "JobDetailModelDTO.h"
#import "RTNetworking+Resume.h"

@implementation JobDetailVM

-(instancetype)initWithJobId:(NSString *)jobId ResumeType:(NSNumber *)resumeType
{
    if (self = [super init])
    {
        self.jobId = jobId;
        self.allResumes = [[NSMutableArray alloc]init];
        self.resumeType = resumeType;
    }
    return self;
}

-(void)getPositionDetail
{
    
    self.load = [TBLoading new];
    [self.load start];
    
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTokenId = @"";
    }
    
    RACSignal *signal = [[RTNetworking shareInstance]getPositionDetailWithTokenId:strTokenId userId:strUser positionId:self.jobId];
    
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        if (self.load) {
            [self.load stop];
        }
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            
            RTLog(@"%@",[dic resultObject]);
            self.data = [JobDetailModelDTO beanFromDictionary:[dic resultObject]];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            //[OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){

        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
        RTLog(@"%@",[error description]);
    }];
}

- (void)stop
{
    if (self.load) {
        [self.load stop];
    }
     self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
}

-(void)sendResume
{
    TBLoading *load = [TBLoading new];
    [load start];
    
    RACSignal *signal = [[RTNetworking shareInstance]resumeDeliveryWithUserId:[[MemoryCacheData shareInstance]userId] tokenId:[[MemoryCacheData shareInstance]userTokenId] positionId:self.jobId resumeId:self.chooseResumeId];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        if (load)
        {
            [load stop];
        }
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        self.sendMessage = [dic resultErrorMessage];
        
        if ([dic resultSucess])
        {
            self.SendResumeStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.SendResumeStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        }
        
    } error:^(NSError *error){
        if (load)
        {
            [load stop];
        }
        @strongify(self);
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        self.SendResumeStateCode = error;
        RTLog(@"%@",[error description]);
    }];
}
-(void)getResume
{
    TBLoading *load = [TBLoading new];
    [load start];
    
    if (self.resumeType.intValue==1) {
        self.resumeType = nil;
    }
    RACSignal *signal = [[RTNetworking shareInstance]getResumeListWithTokenId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId ResumeType:[NSString stringWithFormat:@"%@",self.resumeType ]];
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
            NSArray *array = [dic resultObject];
            if (array && ![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                [self.allResumes addObjectsFromArray:array];
                self.getResumeStatecode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
            else
            {
                self.getResumeStatecode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.getResumeStatecode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                self.getResumeStatecode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
        
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        self.getResumeStatecode = [NSError errorWithErrorMessage:NetWorkError];
        RTLog(@"%@",[error description]);
    }];
}

@end
