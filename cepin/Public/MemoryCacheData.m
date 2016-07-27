//
//  MemoryCacheData.m
//  cepin
//
//  Created by ceping on 14-11-21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "MemoryCacheData.h"
#import "RTNetworking+User.h"
#import "RTNetworking+Chat.h"
#import "RTNetworking+DynamicState.h"

#import "NSDictionary+NetworkBean.h"
#import "JsonModel.h"
#import "UserThirdLoginInfoDTO.h"

@implementation MemoryCacheData

+(MemoryCacheData*)shareInstance
{
    static MemoryCacheData *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = self.new;
    });
    return shareInstance;
}
-(NSString*)userId
{
    return self.userLoginData.UserId;
}
-(NSString*)userTokenId
{
    return self.userLoginData.TokenId;
}
- (NSString *)realName
{
    return self.userLoginData.realName;
}
- (void)setUserLoginData:(UserLoginDTO *)userLoginData
{
    _userLoginData = nil;
    _userLoginData = userLoginData;
}
//-(void)getChatToken
//{
//    
//}
//-(void)getRongYun
//{
//    RACSignal *signal = [[RTNetworking shareInstance] getRongcloudTokenWithTokenId:[[MemoryCacheData shareInstance] userTokenId] userId:[[MemoryCacheData shareInstance] userId]];
//    @weakify(self);
//    [signal subscribeNext:^(RACTuple *tuple){
//        @strongify(self);
//        NSDictionary *dic = tuple.second;
//        RTLog(@" %@",tuple.second);
//        if ([dic resultSucess])
//        {
//            dic = [dic resultObject];
//            self.rongYunTockenId = [dic objectForKey:@"RongYunTokenId"];
//            NSString *tmStr = [dic objectForKey:@"userId32"];
//            self.userId32 = [tmStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    
//            [RCIM connectWithToken:[MemoryCacheData shareInstance].rongYunTockenId completion:^(NSString *userId) {
//                RTLog(@"............融云成功");
//                self.isRongyunLogin = YES;
//            } error:^(RCConnectErrorCode status) {
//                self.isRongyunLogin = NO;
//                RTLog(@"............融云失败");
//            }];
//        }
//        else
//        {
//       
//        }
//        
//    } error:^(NSError *error){
//    }];
//}

//首次登录时上传工作订阅
-(void)uploadJobSearch:(SendSubscriptionJobModelDTO*)bean
{
    RACSignal *signal = [[RTNetworking shareInstance]saveDynamicStateSubscribe:[bean toDictionary]];
    [signal subscribeNext:^(RACTuple *tuple){
    } error:^(NSError *error){
    }];
}
- (void)disConnect
{
    self.userLoginData = nil;
    self.userId32 = nil;
    self.isLogin = NO;
    self.isRongyunLogin = NO;
    self.rongYunTockenId = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPassword"];
    if (self.isThirdLogin)
    {
        self.isThirdLogin = NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"IsThirdPartLogin"];
        [UserThirdLoginInfoDTO disconnect];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginOut" object:nil userInfo:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RealName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RealName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"photourlimagedata"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"photourl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
