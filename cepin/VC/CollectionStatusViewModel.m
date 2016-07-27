//
//  CollectionStatusViewModel.m
//  cepin
//
//  Created by ceping on 14-11-24.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CollectionStatusViewModel.h"
#import "RTNetworking+PublicData.h"
#import "UserLoginDTO.h"
#import "CollectionStatusDTO.h"

@implementation CollectionStatusViewModel

-(instancetype)init
{
    if (self = [super init])
    {
        return self;
    }
    return nil;
}

-(void)run
{
    timer = [NSTimer timerWithTimeInterval:kStartLoadDataTimeOut target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

-(void)timeRun
{
    NSString *strUser = @"";
    NSString *strTocken = @"";
    if ([MemoryCacheData shareInstance].isLogin)
    {
        strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
        strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    }
 
    RACSignal *signal = [[RTNetworking shareInstance]queryCollectionStatusWithTokenId:strTocken userId:strUser];
    
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        
        @strongify(self);
        RTLog(@"collection %@",tuple.second);
        self.stateCode = [self dealDataWithTuple:tuple];
        
    } error:^(NSError *error){
        
        @strongify(self);
        self.stateCode = error;
        
    }];
}

-(void)reStart
{
    if (timer)
    {
        [timer fire];
    }
}

//处理登录数据
- (id)dealDataWithTuple:(RACTuple *)tuple
{
    NSDictionary *dic = (NSDictionary *)tuple.second;
    if ([dic resultSucess]) {
        
        self.dataModel = [CollectionStatusDTO userInfoWithDictionary:[dic resultObject]];
        if (self.dataModel)
        {
            return [RTHUDModel hudWithCode:HUDCodeSucess];
        }
    }
    else
    {
        return [NSError errorWithErrorMessage:[dic resultErrorMessage]];
    }
    return [NSError errorWithErrorType:ErrorTypeLost];
    
}

@end