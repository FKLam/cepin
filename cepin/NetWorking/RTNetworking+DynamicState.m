//
//  RTNetworking+DynamicState.m
//  cepin
//
//  Created by peng on 14-11-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking+DynamicState.h"

@implementation RTNetworking (DynamicState)

//3.3.1 获取动态数量接口
-(RACSignal *)getDynamicStateCountWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_POST:@"DynamicState/GetCount" parameters:@{@"UUID":UUID,@"tokenId":tokenId,@"userId":userId}];
}

// 3.3.2 订阅工作动态接口
/*-(RACSignal *)saveDynamicStateSubscribePositionWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId address:(NSString *)address jobPropertys:(NSString *)jobPropertys salary:(NSString *)salary jobFunctions:(NSString *)jobFunctions industries:(NSString *)industries companyNature:(NSString *)companyNature companySize:(NSString *)companySize
{
    //return [self.httpManager rac_POST:@"DynamicState/SubscribePosition" parameters:parameters];
    return [self.httpManager rac_POST:@"DynamicState/SubscribePosition" parameters:@{@"UUID":UUID,@"tokenId":tokenId,@"userId":userId,@"address":address,@"jobPropertys":jobPropertys,@"salary":salary,@"jobFunctions":jobFunctions,@"industries":industries,@"companyNature":companyNature,@"companySize":companySize}];
    
}*/

-(RACSignal *)saveDynamicStateSubscribe:(NSDictionary*)parameters
{
    return [self.httpManager rac_POST:@"DynamicState/SubscribePosition" parameters:parameters];
}

// 3.3.3 获取订阅工作筛选条件接口
-(RACSignal *)getDynamicStateSubscribePositionWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_POST:@"DynamicState/GetSubscribePosition" parameters:@{@"UUID":UUID,@"tokenId":tokenId,@"userId":userId}];
    
}

// 3.3.4 订阅宣讲会接口
-(RACSignal *)saveDynamicStateSubscribeCampusFairWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId schools:(NSString *)schools
{
    return [self.httpManager rac_POST:@"DynamicState/SubscribeCampusFair" parameters:@{@"UUID":UUID,@"tokenId":tokenId,@"userId":userId,@"schools":schools}];
    
}

// 3.3.5 获取宣讲会筛选条件接口
-(RACSignal *)getDynamicStateSubscribeCampusFairWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_POST:@"DynamicState/GetSubscribeCampusFair" parameters:@{@"UUID":UUID,@"tokenId":tokenId,@"userId":userId}];
    
}

// 3.3.6 获取工作动态接口
-(RACSignal *)getDynamicStatePositionListWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    return [self.httpManager rac_POST:@"DynamicState/GetPositionList" parameters:@{@"UUID":UUID,@"tokenId":tokenId,@"userId":userId,@"PageIndex":[NSString stringWithFormat:@"%d",(int)PageIndex],@"PageSize":[NSString stringWithFormat:@"%d",(int)PageSize]}];
    
}

// 3.3.7 获取宣讲会动态接口
-(RACSignal *)getDynamicStateCampusFairListWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    return [self.httpManager rac_POST:@"DynamicState/GetCampusFairList" parameters:@{@"UUID":UUID,@"tokenId":tokenId,@"userId":userId,@"PageIndex":[NSString stringWithFormat:@"%ld",PageIndex],@"PageSize":[NSString stringWithFormat:@"%ld",(long)PageSize]}];
    
}

// 3.3.8 获取系统消息动态接口
-(RACSignal *)getDynamicStateSystemMessageListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    return [self.httpManager rac_POST:@"DynamicState/GetSystemMessageList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"PageIndex":[NSString stringWithFormat:@"%ld",PageIndex],@"PageSize":[NSString stringWithFormat:@"%ld",(long)PageSize]}];
    
}
/** 获取消息  messageStatus 1：系统 2：企业 */
-(RACSignal *)getMessageListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize messageStatus:(NSString *)messageStatus
{
    return [self.httpManager rac_GET:@"/ThridEdition/User/GetMessageList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"PageIndex":[NSString stringWithFormat:@"%ld",PageIndex],@"PageSize":[NSString stringWithFormat:@"%ld",(long)PageSize], @"messageStatus" : messageStatus}];
}
// 3.3.9 测评中心列表接口
-(RACSignal *)getDynamicStateExamListWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize examStatus:(NSString*)examStatus
{
    return [self.httpManager rac_POST:@"DynamicState/GetExamList" parameters:@{@"UUID":UUID,@"tokenId":tokenId,@"userId":userId,@"PageIndex":[NSString stringWithFormat:@"%ld",PageIndex],@"PageSize":[NSString stringWithFormat:@"%ld",(long)PageSize],@"examStatus":examStatus}];
}
// 3.3.10 企业对话接口
-(RACSignal *)getDynamicStateCompanyMessageListWithTokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_POST:@"DynamicState/GetCompanyMessageList" parameters:@{@"tokenId":tokenId,@"userId":userId}];
}
/** 获取企业邀请测评 */
- (RACSignal *)getMeExamReportWith:(NSString*)userId tokenId:(NSString *)tokenId
{
    return [self.httpManager rac_GET:@"ThridEdition/User/ExamList" parameters:@{@"userId":userId,@"tokenId":tokenId}];
}
/** 获取职位测评、微测评 */
- (RACSignal *)getPersonExamListWith:(NSString*)userId tokenId:(NSString *)tokenId
{
    return [self.httpManager rac_GET:@"/ThridEdition/User/GetPersonExamList" parameters:@{@"userId":userId,@"tokenId":tokenId}];
}
//获取单个站内信
- (RACSignal *)getSystemMessageSingle:(NSString *)userId MsgId:(NSString *)MsgId tokenId:(NSString *)tokenId
{
    return [self.httpManager rac_GET:@"ThridEdition/Common/GetSystemMessage" parameters:@{@"UserId":userId,@"TokenId":tokenId,@"MsgId":MsgId}];
    
}
- (RACSignal *)getCustomerExamListWith:(NSString*)userId tokenId:(NSString *)tokenId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
//    /ThridEdition/User/GetCustomerExamList
    return [self.httpManager rac_GET:@"/ThridEdition/User/GetCustomerExamList" parameters:@{@"userId":userId,@"tokenId":tokenId,@"PageIndex":[NSString stringWithFormat:@"%ld",PageIndex],@"PageSize":[NSString stringWithFormat:@"%ld",(long)PageSize]}];
}
///ThridEdition/User/GetPersonExamList
- (RACSignal *)getSinglPersonExamListWith:(NSString*)userId tokenId:(NSString *)tokenId examStatus:(NSString *)examStatus PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    return [self.httpManager rac_GET:@"/ThridEdition/User/GetPersonExamList" parameters:@{@"userId":userId,@"tokenId":tokenId, @"examStatus":examStatus,@"PageIndex":[NSString stringWithFormat:@"%ld",PageIndex],@"PageSize":[NSString stringWithFormat:@"%ld",(long)PageSize]}];
}
@end
