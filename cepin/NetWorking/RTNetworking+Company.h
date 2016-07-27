//
//  RTNetworking+Company.h
//  cepin
//
//  Created by peng on 14-11-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking.h"

@interface RTNetworking (Company)

/**
 * 3.6企业接口
 
 3.6.1关注企业列表 获取关注企业列表列表
 URL
 http://app2.cepin.com/Company/FocusList
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)getCompanyFocusListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;

/**
 *
 3.6.2公司详情接口 公司详情
 URL
 http://app2.cepin.com/Company/Detail
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)getCompanyDetailWithCustomerId:(NSString *)customerId UserId:(NSString *)UserId;


/**
 *
 3.6.3公司收藏接口 公司收藏
 URL
 http://app2.cepin.com/Company/Collect
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)companyCollectWithCustomerId:(NSString *)customerId UserId:(NSString *)UserId;

/**
 *
 3.6.4公司取消收藏接口 公司消收收藏
 URL
 http://app2.cepin.com/Company/CancelCollect
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)companyCancelCollectWithCustomerId:(NSString *)customerId UserId:(NSString *)UserId;

/**
 *
 3.6.5 公司取消多个收藏接口
 URL
 http://app2.cepin.com/ Company / BatchCancelCollect
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)companyBatchCancelCollectWithCustomerIds:(NSString *)customerIds UserId:(NSString *)UserId;


/**
 *
 3.6.6公司职位接口 获取公司职位列表
 URL
 http://app2.cepin.com/Company/PositionList
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)getCompanyPositionListWithTokenId:(NSString *)tokenId userId:(NSString *)userId customerId:(NSString *)customerId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;

/**
 *
 3.6.7公司宣讲会接口 获取宣讲会收藏列表
 URL
 http://app2.cepin.com/Company/CampusFairList
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)getCompanyCampusFairListWithTokenId:(NSString *)tokenId userId:(NSString *)userId customerId:(NSString *)customerId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;

/**
 *
 查看过我的简历的公司列表
 URL
 http://app2.cepin.com/ThridEdition/Resume/GetViewedResumeCustomerList"
 HTTP请求方式
 POST
 * 查看看过我简历的公司列表
 * @param resumeId
 * @param tokenid
 * @param userid
 * @param pageSize
 * @param pageIndex
 * @return
 */

-(RACSignal *)getViewedResumeListWithTokenId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString *)resumeId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;

@end
