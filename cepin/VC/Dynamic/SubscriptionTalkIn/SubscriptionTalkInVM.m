//
//  SubscriptionTalkInVM.m
//  cepin
//
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SubscriptionTalkInVM.h"
#import "RTNetworking+DynamicState.h"
#import "TalkInFilterModel.h"
#import "TBTextUnit.h"
#import "SchoolDTO.h"

@implementation SubscriptionTalkInVM

-(instancetype)init
{
    if (self = [super init])
    {
        NSString *strUser = [[MemoryCacheData shareInstance]userId];
        if (!strUser)
        {
            strUser = @"";
        }
        
        [[TalkInFilterModel shareInstance]reloadWithFileName:strUser];
        
        return self;
    }
    return nil;
}

-(void)getSubscriptionTalkIn
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTokenId = @"";
    }

    RACSignal *signal = [[RTNetworking shareInstance]getDynamicStateSubscribeCampusFairWithUUID:UUID_KEY tokenId:strTokenId userId:strUser];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            SubscriptionTalkModelDTO *bean = [SubscriptionTalkModelDTO beanFromDictionary:[dic resultObject]];
            RTLog(@"%@",bean);
            
            [[TalkInFilterModel shareInstance].schools removeAllObjects];
            [[TalkInFilterModel shareInstance].schools addObjectsFromArray:[School searchSchoolsWithShoolNames:bean.schools]];
            [[TalkInFilterModel shareInstance]saveObjectToDiskWithFile:strUser];
            
            //[OMGToast showWithText:NetWorkOprationSuccess bottomOffset:40 duration:2.f];
            
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:40 duration:2.f];
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        [OMGToast showWithText:NetWorkError bottomOffset:40 duration:2.f];
        self.stateCode = error;
        RTLog(@"%@",[error description]);
    }];
}

-(void)saveSubscription
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTokenId = @"";
    }

    //self.viewModel.schoolsString = [TBTextUnit schoolNamesWithSchools:[[TalkInFilterModel shareInstance] schools]];
    
    RACSignal *signal = [[RTNetworking shareInstance]saveDynamicStateSubscribeCampusFairWithUUID:UUID_KEY tokenId:strTokenId userId:strUser schools:[TBTextUnit schoolNamesWithSchools:[[TalkInFilterModel shareInstance] schools]]];
    
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            RTLog(@"%@",[dic resultObject]);
            
            [[TalkInFilterModel shareInstance]saveObjectToDiskWithFile:strUser];
            
            [OMGToast showWithText:NetWorkOprationSuccess bottomOffset:40 duration:2.f];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeSystemBooking" object:nil userInfo:nil];
            
            self.SaveStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:40 duration:2.f];
            self.SaveStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        [OMGToast showWithText:NetWorkError bottomOffset:40 duration:2.f];
        self.SaveStateCode = error;
        RTLog(@"%@",[error description]);
    }];
}

-(void)deleteSubscription
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTokenId = @"";
    }
    
    RACSignal *signal = [[RTNetworking shareInstance]saveDynamicStateSubscribeCampusFairWithUUID:UUID_KEY tokenId:strTokenId userId:strUser schools:@""];
    
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            RTLog(@"%@",[dic resultObject]);
            [[TalkInFilterModel shareInstance]deleteObjectFromNet:strUser];
            [OMGToast showWithText:NetWorkOprationSuccess bottomOffset:40 duration:2.f];
            self.DeleteStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:40 duration:2.f];
            self.DeleteStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        [OMGToast showWithText:NetWorkError bottomOffset:40 duration:2.f];
        self.DeleteStateCode = error;
        RTLog(@"%@",[error description]);
    }];
}


@end
