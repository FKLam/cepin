//
//  RecommendVM.m
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "RecommendVM.h"
#import "RTNetworking+Position.h"
#import "BookingJobFilterModel.h"
#import "RTNetworking+Banner.h"
#import "TBTextUnit.h"
#import "JobSearchModel.h"
#import "CPRecommendPositionCacheReformer.h"
#import "CPHomeBannerCacheReformer.h"
#import "RTNetworking+User.h"
#import "UserThirdLoginInfoDTO.h"
@interface RecommendVM ()
@property (nonatomic, assign) NSInteger offset;
@end
@implementation RecommendVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bannerDatas = [NSMutableArray new];
        self.positionIdArray = [NSMutableArray new];
        self.isLoad = YES;
        self.offset = 0;
    }
    return self;
}
- (void)allPositionId
{
    self.positionIdArray = [PositionIdModel allPositionIds];
}
- (void)checkVersionUpdateFromeServer
{
    NSString *typeString = @"2";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    RACSignal *signal = [[RTNetworking shareInstance] getVersionWithType:typeString version:currentVersion];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple)
     {
         @strongify(self);
         NSDictionary *dic = (NSDictionary *)tuple.second;
         if ([dic resultSucess])
         {
             self.updateVersionDict = [dic resultObject];
             self.updateVersionStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
         }
         else
         {
             self.updateVersionStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
         }
     } error:^(NSError *error)
     {
         NSLog(@"%p", __func__);
     }];
}
-(void)loadDataWithPage:(NSInteger)page
{
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if (!strUser)
    {
        strUser = @"";
        strTocken = @"";
    }
    self.TBLoad = nil;
    if (self.isLoad) {
        self.TBLoad = [TBLoading new];
        self.TBLoad.isWaitFor = YES;
        [self.TBLoad start];
        self.isLoad = NO;
    }
    if(0 == [self.cityCode length] || nil == self.cityCode || NULL == self.cityCode || [self.cityCode isKindOfClass:[NSNull class]]){
        self.cityCode = @"";
    }
    if ( 1 == page )
    {
        self.offset = 0;
    }
    // 请求最新发布的数据
    RACSignal *signal = [[RTNetworking shareInstance] getPositionWithTokenId:nil userId:nil PageIndex:self.page PageSize:self.size City:self.cityCode];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple)
    {
        if ( 1 == self.page )
        {
            [self.allRecommendPositionArrayM removeAllObjects];
            [self.allRecommendPositionDictArrayM removeAllObjects];
            [self.visiabelRecommendPositionArrayM removeAllObjects];
            [self.visiabelRecommendPositionDictArrayM removeAllObjects];
            [self.datas removeAllObjects];
        }
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            if ( [self.allRecommendPositionArrayM count] > 0 )
            {
                [self addVisiabelRecommend];
                if ( [self.visiabelRecommendPositionArrayM count] >= 30 )
                    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
            else
            {
                NSArray *array = [dic resultObject];
                if (array)
                {
                    if ( 30 < [array count] )
                    {
                        for ( NSInteger index = 0; index < 30; index++ )
                        {
                            [self.allRecommendPositionDictArrayM addObject:array[index]];
                        }
                    }
                    else
                    {
                        [self.allRecommendPositionDictArrayM addObjectsFromArray:array];
                    }
                    [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[JobSearchModel class]];
                    [self.allRecommendPositionArrayM addObjectsFromArray:self.datas];
                    [self setupRecommendCache];
                }
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
        }
        else
        {
            if ( [self.datas count] > 0 )
            {
                [self addVisiabelRecommend];
            }
            if (self.page == 1)
            {
                [self.datas removeAllObjects];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
            else
            {
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
        }
        if (self.TBLoad)
        {
            [self.TBLoad stop];
        }
    } error:^(NSError *error)
    {
        @strongify(self);
        if ( 0 == [self.allRecommendPositionArrayM count] )
        {
            NSArray *tempArray = [CPRecommendPositionCacheReformer positionDictsWithParams:nil];
            [self dealDataAndStateCodeWithPage:self.page bean:tempArray modelClass:[JobSearchModel class]];
            [self.allRecommendPositionArrayM addObjectsFromArray:self.datas];
            self.datas = nil;
        }
        else
        {
            self.recommendStateCode = [RTHUDModel hudWithCode:hudCodeUpdateSucess];
        }
        if ( 0 == [self.visiabelRecommendPositionArrayM count] )
            [self.visiabelRecommendPositionArrayM addObjectsFromArray:self.allRecommendPositionArrayM];
        [self addVisiabelRecommend];
        self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
        if(self.TBLoad)
        {
            [self.TBLoad stop];
        }
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if(self.load)
//        {
//            [self.load stop];
//        }
//    });
}
-(void)stop
{
    if (self.TBLoad) {
        [self.TBLoad stop];
    }
     self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
     self.isLoad = YES;
}
-(void)getBanner
{
    RACSignal *signal = [[RTNetworking shareInstance] getBanner:2];
    @weakify(self)
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.bannerDatas = [dic resultObject];
            [self setupHomeBannerCache];
            self.bannerStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.bannerStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        }
    } error:^(NSError *error){
        [self getBannerCache];
    }];
}
- (void)HomeAutoLogin
{
//    if ( [MemoryCacheData shareInstance].isLogin )
//        return;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsThirdPartLogin"];
    if (number && number.intValue == 1)
    {
        [self performSelectorInBackground:@selector(homeThirdPartLogin) withObject:nil];
    }
    else
    {
        [self performSelectorInBackground:@selector(homeNormalLogin) withObject:nil];
    }
}
-(void)homeNormalLogin
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccout"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"];
        if (!account || !password)
        {
            return;
        }
        // inviteCode 渠道号
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sourceid" ofType:@"txt"];
        NSString *inviteCode = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        if ( !inviteCode || 0 == [inviteCode length] )
            inviteCode = @"AppStore";
        RACSignal *signal = [[RTNetworking shareInstance] loginWithAccount:account password:password inviteCode:inviteCode];
        [signal subscribeNext:^(RACTuple *tuple){
            NSDictionary *dic = tuple.second;
            if ([dic resultSucess])
            {
                UserLoginDTO *login = [UserLoginDTO beanFromDictionary:[dic resultObject]];
                if (login)
                {
                    [MemoryCacheData shareInstance].userLoginData = login;
                    [MemoryCacheData shareInstance].isLogin = YES;
                    [MemoryCacheData shareInstance].isThirdLogin = NO;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"IsThirdPartLogin"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                self.homeAutoLoginStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
                [self updateApptoken];
            }
            else
            {
                self.homeAutoLoginStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
        } error:^(NSError *error){
            self.homeAutoLoginStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        }];
//    });
}
-(void)updateApptoken{
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    NSString *apptoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"uapp_token"];
//    NSLog(@"%@", apptoken);
    if (!strTocken || !apptoken) {
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance] updateAppTokenWithUserId:strUser tokenId:strTocken appDeviceToken:apptoken];
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
                        NSLog(@"上传apptoken成功");
        }else{
                        NSLog(@"上传apptoken失败");
        }
    } error:^(NSError *error){
    }];
}
-(void)homeThirdPartLogin
{
    UserThirdLoginInfoDTO *thirdPart = [UserThirdLoginInfoDTO info];
    if (!thirdPart || !thirdPart.type || !thirdPart.usid || !thirdPart.username)
    {
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance] thirdPartLoginWithUID:thirdPart.usid userName:thirdPart.username type:thirdPart.type];
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = tuple.second;
        if ([dic resultSucess])
        {
            UserLoginDTO *login = [UserLoginDTO beanFromDictionary:[dic resultObject]];
            if (login)
            {
                [MemoryCacheData shareInstance].userLoginData = login;
                [MemoryCacheData shareInstance].isLogin = YES;
                [MemoryCacheData shareInstance].isThirdLogin = YES;
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"IsThirdPartLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginOver" object:nil userInfo:nil];
            }
            self.homeAutoLoginStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.homeAutoLoginStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        }
    } error:^(NSError *error){
        self.homeAutoLoginStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
    }];
}
- (void)setupHomeBannerCache
{
    [CPHomeBannerCacheReformer clearup];
    [self addVisiabelBannerCache];
}
- (void)addVisiabelBannerCache
{
    CPGuessYouLikePositionParam *params = [[CPGuessYouLikePositionParam alloc] init];
    NSInteger count = [self.bannerDatas count];
    params.pageString = [NSString stringWithFormat:@"%ld", (long)count];
    params.userid = [MemoryCacheData shareInstance].userLoginData.UserId;
    for ( NSDictionary *dict in self.bannerDatas )
    {
        [CPHomeBannerCacheReformer addBannerDict:dict params:params];
    }
}
- (void)getBannerCache
{
    [self.bannerDatas addObjectsFromArray:[CPHomeBannerCacheReformer bannerDictsWithParams:nil]];
    self.bannerStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
}
- (void)setupRecommendCache
{
    [CPRecommendPositionCacheReformer clearup];
    [self addVisiabelRecommend];
}
- (void)addVisiabelRecommend
{
    if ( [self.visiabelRecommendPositionArrayM count] >= [self.allRecommendPositionArrayM count] )
    {
        self.recommendStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        return;
    }
    NSInteger count = [self.allRecommendPositionArrayM count];
    NSInteger tempOffset = self.offset + 10;
    tempOffset = tempOffset > count ? count : tempOffset;
    for ( NSInteger index = self.offset; index < tempOffset; index++ )
    {
        [self.visiabelRecommendPositionArrayM addObject:self.allRecommendPositionArrayM[index]];
        if ( [self.datas count] > 0 )
        {
            [self.visiabelRecommendPositionDictArrayM addObject:self.allRecommendPositionDictArrayM[index]];
            [self saveRecommendCache:self.allRecommendPositionDictArrayM[index]];
        }
    }
    if ( self.offset < [self.allRecommendPositionArrayM count] - 10 )
        self.recommendStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
    else
        self.recommendStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
    self.offset += 10;
}
- (void)clickedMoreButton
{
    if ( [self.visiabelRecommendPositionArrayM count] >= [self.allRecommendPositionArrayM count] )
    {
        return;
    }
    NSInteger count = [self.allRecommendPositionArrayM count];
    NSInteger tempOffset = self.offset + 10;
    tempOffset = tempOffset > count ? count : tempOffset;
    for ( NSInteger index = self.offset; index < tempOffset; index++ )
    {
        [self.visiabelRecommendPositionArrayM addObject:self.allRecommendPositionArrayM[index]];
        if ( [self.datas count] > 0 )
        {
            [self.visiabelRecommendPositionDictArrayM addObject:self.allRecommendPositionDictArrayM[index]];
            if ( self.datas )
                [self saveRecommendCache:self.allRecommendPositionDictArrayM[index]];
        }
    }
    self.offset += 10;
}
- (void)saveRecommendCache:(NSDictionary *)dict
{
    CPGuessYouLikePositionParam *params = [[CPGuessYouLikePositionParam alloc] init];
    NSInteger count = [self.visiabelRecommendPositionDictArrayM count] / 10;
    params.pageString = [NSString stringWithFormat:@"%ld", (long)count];
    params.userid = [MemoryCacheData shareInstance].userLoginData.UserId;
    [CPRecommendPositionCacheReformer addRecommendPositionDict:dict params:params];
}
- (NSMutableArray *)visiabelRecommendPositionArrayM
{
    if ( !_visiabelRecommendPositionArrayM )
    {
        _visiabelRecommendPositionArrayM = [NSMutableArray array];
    }
    return _visiabelRecommendPositionArrayM;
}
- (NSMutableArray *)allRecommendPositionArrayM
{
    if ( !_allRecommendPositionArrayM )
    {
        _allRecommendPositionArrayM = [NSMutableArray array];
    }
    return _allRecommendPositionArrayM;
}
- (NSMutableArray *)visiabelRecommendPositionDictArrayM
{
    if ( !_visiabelRecommendPositionDictArrayM )
    {
        _visiabelRecommendPositionDictArrayM = [NSMutableArray array];
    }
    return _visiabelRecommendPositionDictArrayM;
}
- (NSMutableArray *)allRecommendPositionDictArrayM
{
    if ( !_allRecommendPositionDictArrayM )
    {
        _allRecommendPositionDictArrayM = [NSMutableArray array];
    }
    return _allRecommendPositionDictArrayM;
}
@end