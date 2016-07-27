//
//  NewJobDetialVM.m
//  cepin
//
//  Created by dujincai on 15/5/20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "NewJobDetialVM.h"
#import "RTNetworking+Position.h"
#import "RTNetworking+Company.h"
#import "RTNetworking+Resume.h"
@implementation NewJobDetialVM
-(instancetype)initWithJobId:(NSString *)jobId companyId:(NSString *)comanyId
{
    self = [super init];
    if (self) {
        self.jobId = jobId;
        self.companyId = comanyId;
        [PositionIdModel savePositionIdWith:jobId];
    }
    return self;
}
- (void)allPositionId
{
    self.positionIdArray = [PositionIdModel allPositionIds];
}
- (void)getPositionDetail
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance] userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTokenId = @"";
    }
    if (!self.isLoad)
    {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = YES;
    }
    RACSignal *signal = [[RTNetworking shareInstance] getPositionDetailWithTokenId:strTokenId userId:strUser positionId:self.jobId];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.positionDetail = [dic resultObject];
            self.data = [JobDetailModelDTO beanFromDictionary:self.positionDetail];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            [self savePositionDetail:[dic resultObject]];
        }
        else
        {
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } error:^(NSError *error){
        @strongify(self);
        [self getPositionDetailCache];
        self.stateCode = error;
    }];
}
- (void)savePositionDetail:(NSDictionary *)dict
{
    CPPositionDetailParam *params = [[CPPositionDetailParam alloc] init];
    params.positionID = self.jobId;
    params.companyID = self.companyId;
    params.userID = [[MemoryCacheData shareInstance] userId];
    [CPPositionDetailCacheReformer addGuessYouLikePositionDict:dict params: params];
}
- (void)getPositionDetailCache
{
    CPPositionDetailParam *params = [[CPPositionDetailParam alloc] init];
    params.positionID = self.jobId;
    params.companyID = self.companyId;
    NSDictionary *dict = [CPPositionDetailCacheReformer positionDictWithParams:params];
    self.positionDetail = dict;
}
-(void)collectionJob
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    RACSignal *signal = [[RTNetworking shareInstance] positionCollectWithUserId:strUser positionId:self.jobId];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            [OMGToast showWithText:@"收藏成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
            self.collectionJobStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
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
            self.collectionJobStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } error:^(NSError *error){
        @strongify(self);
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout ];
        self.collectionJobStateCode = error;
        RTLog(@"%@",[error description]);
    }];
}
-(void)deleteJob
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    //NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    RACSignal *signal = [[RTNetworking shareInstance]positionCancelCollectWithUserId:strUser positionId:self.jobId];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            [OMGToast showWithText:@"取消收藏成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
            self.deleteJobStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
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
            self.deleteJobStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout ];
        self.deleteJobStateCode = error;
        RTLog(@"%@",[error description]);
    }];
}
//公司
-(void)getCompanyDetail
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance] userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTokenId = @"";
    }
    RACSignal *signal = [[RTNetworking shareInstance]getCompanyDetailWithCustomerId:self.companyId UserId:strUser];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            RTLog(@"%@",[dic resultObject]);
            self.companyData = [CompanyDetailModelDTO beanFromDictionary:[dic resultObject]];
            self.companyDict = [dic resultObject];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        }
    } error:^(NSError *error){
        @strongify(self);
        self.stateCode = error;
        RTLog(@"%@",[error description]);
        self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
    }];
}
-(void)deleteCompany
{
    if (![MemoryCacheData shareInstance].isLogin)
    {
        self.deleteCompanyStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
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
            [OMGToast showWithText:@"取消收藏成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
            self.deleteCompanyStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.deleteCompanyStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } error:^(NSError *error){
      
        RTLog(@"%@",[error description]);
    }];
}
-(void)saveCompany
{
    if (![MemoryCacheData shareInstance].isLogin)
    {
        self.saveCompanyStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        return;
    }
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    RACSignal *signal = [[RTNetworking shareInstance]companyCollectWithCustomerId:self.companyId UserId:strUser];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            [OMGToast showWithText:@"收藏成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];

            self.saveCompanyStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.saveCompanyStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout ];
        self.saveCompanyStateCode = error;
        RTLog(@"%@",[error description]);
    }];
}
- (void)resumeDeliveryWithResumeID:(NSString *)resumeID
{
    self.load = nil;
    if (!self.isLoad)
    {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = YES;
    }
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    RACSignal *signal = [[RTNetworking shareInstance] resumeDeliveryWithUserId:strUser tokenId:strTokenId positionId:self.jobId resumeId:resumeID];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        self.message = [dic resultMessage];
        if ([dic resultSucess])
        {
            self.deliveryResumeStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.deliveryResumeStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        }
        if (self.load)
        {
            [self.load stop];
            self.isLoad = NO;
        }
    } error:^(NSError *error){
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout ];
        self.deliveryResumeStateCode = error;
        if (self.load)
        {
            [self.load stop];
            self.isLoad = NO;
        }
    }];
}
- (void)getAllResumeWithPositionType:(NSNumber *)positionType
{
    NSString *tokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if (!tokenId) {
        if (self.load)
        {
            [self.load stop];
            self.isLoad = NO;
        }
        return;
    }
//    if (!self.isLoad)
//    {
//        self.load = [TBLoading new];
//        [self.load start];
//        self.isLoad = YES;
//    }
    self.isSuccessGetAllResume = NO;
    NSString *resumeTypeString = @"";
    // 校招职位
    if ( 1 == [positionType intValue] )
        resumeTypeString = @"2";
    RACSignal *signal = [[RTNetworking shareInstance] getResumeListWithTokenId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId ResumeType:[NSString stringWithFormat:@"%@", resumeTypeString]];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            if (array &&  ![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                [self.resumeArrayM removeAllObjects];
                for ( NSDictionary *dict in array )
                {
                    [self.resumeArrayM addObject:[ResumeNameModel beanFromDictionary:dict]];
                }
            }
            self.isSuccessGetAllResume = YES;
        }
        else
        {
            NSLog(@"%@", [dic resultErrorMessage]);
        }
        if (self.load)
        {
            [self.load stop];
            self.isLoad = NO;
        }
    } error:^(NSError *error){
        if (self.load)
        {
            [self.load stop];
            self.isLoad = NO;
        }
    }];
}
- (void)regetAllResumeWithPositionType:(NSNumber *)positionType
{
    NSString *tokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if (!tokenId) {
        return;
    }
    self.isLoad = NO;
    if (!self.isLoad)
    {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = YES;
    }
    self.isSuccessGetAllResume = NO;
    NSString *resumeTypeString = @"";
    // 校招职位
    if ( 1 == [positionType intValue] )
        resumeTypeString = @"2";
    RACSignal *signal = [[RTNetworking shareInstance] getResumeListWithTokenId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId ResumeType:[NSString stringWithFormat:@"%@", resumeTypeString]];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            if (array &&  ![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                [self.resumeArrayM removeAllObjects];
                for ( NSDictionary *dict in array )
                {
                    [self.resumeArrayM addObject:[ResumeNameModel beanFromDictionary:dict]];
                }
            }
            self.isSuccessGetAllResume = YES;
        }
        else
        {
            NSLog(@"%@", [dic resultErrorMessage]);
        }
        if (self.load)
        {
            [self.load stop];
            self.isLoad = NO;
        }
    } error:^(NSError *error){
        if (self.load)
        {
            [self.load stop];
            self.isLoad = NO;
        }
    }];
}
- (NSMutableArray *)resumeArrayM
{
    if ( !_resumeArrayM )
    {
        _resumeArrayM = [NSMutableArray array];
    }
    return _resumeArrayM;
}
@end