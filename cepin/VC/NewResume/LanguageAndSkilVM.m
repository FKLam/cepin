//
//  LanguageAndSkilVM.m
//  cepin
//
//  Created by dujincai on 15/7/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "LanguageAndSkilVM.h"
#import "RTNetworking+Resume.h"
@implementation LanguageAndSkilVM

- (instancetype)initWithResumeId:(NSString*)resumeId
{
    self = [super init];
    if (self) {
        self.resumeModel = [ResumeNameModel new];
        self.resumeId = resumeId;
    }
    return self;
}

- (void)getResumeInfo
{
    self.load = [TBLoading new];
    [self.load start];
    
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    
    RACSignal *signal = [[RTNetworking shareInstance]getThridResumeDetailWithResumeId:self.resumeId userId:userId tokenId:TokenId];
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
            self.resumeModel = [ResumeNameModel beanFormDic:[dic resultObject]];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
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
@end
