//
//  RTNetworking+DynamicState.h
//  cepin
//
//  Created by peng on 14-11-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking.h"

@interface RTNetworking (DynamicState)

/**
 * 动态接口
 
 3.3.1 获取动态数量接口
 URL
 http://app2.cepin.com/DynamicState/GetCount
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数

 */

-(RACSignal *)getDynamicStateCountWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId;

/**
 *
 接口说明
 
 3.3.2 订阅工作动态接口
 URL
 http://app2.cepin.com/DynamicState/SubscribePosition
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

//-(RACSignal *)saveDynamicStateSubscribePositionWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId address:(NSString *)address jobPropertys:(NSString *)jobPropertys salary:(NSString *)salary jobFunctions:(NSString *)jobFunctions industries:(NSString *)industries companyNature:(NSString *)companyNature companySize:(NSString *)companySize;

-(RACSignal *)saveDynamicStateSubscribe:(NSDictionary*)parameters;

/**
 *
 接口说明
 
 3.3.3 获取订阅工作筛选条件接口
 URL
 http://app2.cepin.com/DynamicState/GetSubscribePosition
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)getDynamicStateSubscribePositionWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId;

/**
 *
 接口说明
 
 3.3.4 订阅宣讲会接口
 URL
 http://app2.cepin.com/DynamicState/SubscribeCampusFair
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)saveDynamicStateSubscribeCampusFairWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId schools:(NSString *)schools;

/**
 *
 接口说明
 
 3.3.5 获取宣讲会筛选条件接口
 URL
 http://app2.cepin.com/DynamicState/GetSubscribeCampusFair
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)getDynamicStateSubscribeCampusFairWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId;

/**
 *
 接口说明
 
 3.3.6 获取工作动态接口
 URL
 http://app2.cepin.com/DynamicState/GetPositionList
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)getDynamicStatePositionListWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;

/**
 *
 接口说明
 
 3.3.7 获取宣讲会动态接口
 URL
 http://app2.cepin.com/DynamicState/GetCampusFairList
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)getDynamicStateCampusFairListWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;

/**
 *
 接口说明
 
 3.3.8 获取系统消息动态接口
 URL
 http://app2.cepin.com/DynamicState/GetSystemMessageList
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)getDynamicStateSystemMessageListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;

/**
 *
 接口说明
 
 3.3.9 测评中心列表接口
 URL
 http://app2.cepin.com/DynamicState/GetExamList
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)getDynamicStateExamListWithUUID:(NSString *)UUID tokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize examStatus:(NSString*)examStatus;
/**
 *
 接口说明
 
 3.3.10 企业对话接口
 URL
 http://app2.cepin.com/DynamicState/GetCompanyMessageList
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)getDynamicStateCompanyMessageListWithTokenId:(NSString *)tokenId userId:(NSString *)userId;



- (RACSignal *)getMeExamReportWith:(NSString*)userId tokenId:(NSString*)tokenId;

//3.1获取单个站内信
- (RACSignal *)getSystemMessageSingle:(NSString*)userId MsgId:(NSString*)MsgId tokenId:(NSString*)tokenId;

/** 获取职位测评、微测评 */
- (RACSignal *)getPersonExamListWith:(NSString*)userId tokenId:(NSString *)tokenId;

- (RACSignal *)getCustomerExamListWith:(NSString*)userId tokenId:(NSString *)tokenId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;
- (RACSignal *)getSinglPersonExamListWith:(NSString*)userId tokenId:(NSString *)tokenId examStatus:(NSString *)examStatus PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;
/** 获取消息  messageStatus 1：系统 2：企业 */
-(RACSignal *)getMessageListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize messageStatus:(NSString *)messageStatus;
@end
