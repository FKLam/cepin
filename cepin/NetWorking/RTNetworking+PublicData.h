//
//  RTNetworking+PublicData.h
//  cepin
//
//  Created by peng on 14-11-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking.h"

@interface RTNetworking (PublicData)

/**
 3.2  公共数据获取接口
 
 *  接口说明
 3.2.1  查询基础数据是否有更新。
 URL
 http://app2.cepin.com/User/UpdateDB
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)queryUpdataDBWithVersion:(NSString *)version;

/**

 *  接口说明
 3.2.2  收藏及关注数量接口。
 URL
 http://app2.cepin.com/User/CollectionCount
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)queryCollectionCountWithTokenId:(NSString *)tokenId userId:(NSString *)userId;

/**
 
 *  接口说明
 3.2.3  收藏及关注状态改变接口
 URL
 http://app2.cepin.com/User/CollectionStatus
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)queryCollectionStatusWithTokenId:(NSString *)tokenId userId:(NSString *)userId;


/**
 
 *  接口说明
 3.2.3  我的测评未完成数
 URL
 http://app2.cepin.com/User/CollectionStatus
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)GetUnExamsCountWithTokenId:(NSString *)tokenId userId:(NSString *)userId;


/**
 
 *  接口说明
 3.2.4  App启动后时接口
 URL
 http://app2.cepin.com/Common/OpenApp
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)openAppWithUUID:(NSString *)UUID openRefer:(NSString *)openRefer;

/**
 
 *  接口说明
 3.2.5  点击探索时同时调用该接口
 URL
 http://app2.cepin.com/Common/UpdateNewsTime
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)upDataNewsTimeWithUUID:(NSString *)UUID userId:(NSString *)userId;

/**
 * 接口说明
 3.2.6  首页切换城市，搜索页面城市筛选，简历城市筛选
 获取热门城市
 *
 */
-(RACSignal *)getHotCityData;

// 3.2 获取个人中心信息
-(RACSignal *)getUnOperationCountWithUserId:(NSString *)userId;
@end
