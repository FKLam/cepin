//
//  CompanyDetailVM.m
//  cepin
//
//  Created by ceping on 14-12-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CompanyDetailVM.h"
#import "RTNetworking+Company.h"

@implementation CompanyDetailVM

-(instancetype)initWithCompanyId:(NSString *)cId
{
    if (self = [super init]) {
        self.companyId = cId;
        self.isOpen = NO;
        self.isLoad = NO;
    }
    return self;
}

- (void)allPositionId
{
    self.positionIdArray = [PositionIdModel allPositionIds];
}

-(void)getCompanyDetail
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance] userTokenId];
    
    if (!strUser || [strUser length] == 0)
    {
        strUser = @"";
        strTokenId = @"";
    }
    
    if (self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
    }
    
    
    RACSignal *signal = [[RTNetworking shareInstance] getCompanyDetailWithCustomerId:self.companyId UserId:strUser];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){

        @strongify(self);
        if (self.load)
        {
            [self.load stop];
        }
        
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            RTLog(@"%@",[dic resultObject]);
            self.data = [CompanyDetailModelDTO beanFromDictionary:[dic resultObject]];
            
//            NSArray *array = [dic resultObject];
//            
//            self.data = [CPRecommendModelFrame framesWithArray:array modelClass:[JobSearchModel class]];
            
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
      
        RTLog(@"%@",[error description]);
    }];
}

- (void)stop
{
    if (self.load)
    {
        [self.load stop];
    }
    
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
}

-(void)deleteCompany
{
    if (![MemoryCacheData shareInstance].isLogin)
    {
        self.deleteStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        return;
    }
    
    NSString *strUser = [[MemoryCacheData shareInstance]userId];

    RACSignal *signal = [[RTNetworking shareInstance]companyCancelCollectWithCustomerId:self.companyId UserId:strUser];
    
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            [OMGToast showWithText:@"取消收藏成功" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            self.deleteStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
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
            self.deleteStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        //@strongify(self);
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout ];
        self.deleteStateCode = error;
        RTLog(@"%@",[error description]);
    }];
}
-(void)saveCompany
{
    if (![MemoryCacheData shareInstance].isLogin)
    {
        self.saveStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        return;
    }
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    RACSignal *signal = [[RTNetworking shareInstance] companyCollectWithCustomerId:self.companyId UserId:strUser];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            [OMGToast showWithText:@"收藏成功" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            self.saveStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
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
            self.saveStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        //@strongify(self);
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout ];
        self.saveStateCode = error;
        RTLog(@"%@",[error description]);
    }];
}

-(void)momeryRelease
{
    self.companyId = nil;
    if (self.data)
    {
        [self.data memoryRelease];
        self.data = nil;
    }
}

@end
