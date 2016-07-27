//
//  DynamicSystemVM.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicSystemVM.h"
#import "RTNetworking+DynamicState.h"
#import "DynamicSystemModelDTO.h"

@implementation DynamicSystemVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLoad = YES;
        self.size = 10;
    }
    return self;
}
-(void)loadDataWithPage:(NSInteger)page
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTocken = [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTocken = @"";
    }
    
    if (self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = NO;
    }
    
    //判断请求的是企业消息还是系统消息
    if(self.isCompanyData){
        //企业消息
        RACSignal *companySignal = [[RTNetworking shareInstance] getMessageListWithTokenId:strTocken userId:strUser PageIndex:self.page PageSize:10 messageStatus:@"2"];
        @weakify(self);
        [companySignal subscribeNext:^(RACTuple *tuple){
            if (self.load)
            {
                [self.load stop];
            }
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)tuple.second;
            if ([dic resultSucess])
            {
                NSArray *array = [dic resultObject];
                RTLog(@"%@",array);
                if (array)
                {
            #pragma waring - 待处理。。。
                    [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[DynamicSystemModelDTO class]];
                }
            }
            else
            {
                if (self.page == 1)
                {
                    [self.datas removeAllObjects];
                    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
                }
                
                // LFK禁止弹出我的消息没有更多的提示
                //            [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
        } error:^(NSError *error){
            [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
        }];
    }else{
        //系统消息
        RACSignal *systemSignal = [[RTNetworking shareInstance] getMessageListWithTokenId:strTocken userId:strUser PageIndex:self.page PageSize:10 messageStatus:@"1"];
        @weakify(self);
        [systemSignal subscribeNext:^(RACTuple *tuple){
            if (self.load)
            {
                [self.load stop];
            }
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)tuple.second;
            if ([dic resultSucess])
            {
                NSArray *array = [dic resultObject];
                RTLog(@"%@",array);
                if (array)
                {
            #pragma waring - 待处理。。。
                    [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[DynamicSystemModelDTO class]];
                }
            }
            else
            {
                if (self.page == 1)
                {
                    [self.datas removeAllObjects];
                    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
                }
                
                // LFK禁止弹出我的消息没有更多的提示
                //            [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
        } error:^(NSError *error){
            [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
        }];
    }
    
}

- (void)stop
{
    if (self.load)
    {
        [self.load stop];
    }
    self.isLoad = YES;
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
}

@end
