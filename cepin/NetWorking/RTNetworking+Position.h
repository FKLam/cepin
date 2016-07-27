//
//  RTNetworking+Position.h
//  cepin
//
//  Created by peng on 14-11-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking.h"


@interface RTNetworking (Position)

/**
 * 3.7职位接口
 
 3.7.1职位收藏列表 获取收藏职位列表
 URL
 http://app2.cepin.com/Position/CollectionList
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)getPositionCollectionListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;

/**
 *
 3.7.2职位详情接口 获取职位详情
 URL
 http://app2.cepin.com/Position/Detail
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)getPositionDetailWithTokenId:(NSString *)tokenId userId:(NSString *)userId positionId:(NSString *)positionId;

/**
 *
 3.7.3职位收藏接口
 URL
 http://app2.cepin.com/Position/Collect
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)positionCollectWithUserId:(NSString *)UserId positionId:(NSString *)positionId;

/**
 *
 3.7.4职位取消收藏接口
 URL
 http://app2.cepin.com/Position/CancelCollect
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)positionCancelCollectWithUserId:(NSString *)UserId positionId:(NSString *)positionId;

/**
 *
 3.7.5 职位取消多个收藏接口
 URL
 http://app2.cepin.com/ Position / BatchCancelCollect
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)positionBatchCancelCollectWithUserId:(NSString *)UserId positionIds:(NSString *)positionIds;

/**
 *
 3.7.6职位搜索接口
 URL
 http://app2.cepin.com/Position/Search
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)getPositionSeachWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize Key:(NSString *)Key t:(NSInteger)t city:(NSString*)city nature:(NSString*)nature salary:(NSString*)salary;

/**
 *
 3.7.7职位筛选搜索
 URL
 http://app2.cepin.com/ Position / Filter
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)getPositionFilterWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize city:(NSString *)city Nature:(NSInteger)Nature Salary:(NSString *)Salary;


/**
 *
 3.7.6职位搜索接口
 URL
 http://app2.cepin.com/Position/Search
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数
 
 */
-(RACSignal *)getPositionSeachWithJobFunction:(NSString *)jobFunction EmployType:(NSString *)employType SalaryMin:(NSInteger)salaryMin SalaryMax:(NSInteger)salaryMax SearchKey:(NSString *)searchKey city:(NSString*)city WorkYear:(NSString*)workYear;

//相似职位
-(RACSignal *)positionSimilarityWithSize:(NSInteger)size positionIds:(NSString *)positionIds tokenId:(NSString *)tokenId userId:(NSString *)userId;


//首页推荐
-(RACSignal *)getPositionWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize City:(NSString *)city;


//3.0职位搜索
-(RACSignal *)getPositionSeachWithPageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize JobFunction:(NSString *)JobFunction city:(NSString*)city EmployType:(NSString*)EmployType Salary:(NSString*)Salary WorkYear:(NSString*)WorkYear SearchKey:(NSString*)SearchKey PositonType:(NSString*)PositonType;

//3.2职位搜索
-(RACSignal *)getPositionSeachWithPageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize JobFunction:(NSString *)JobFunction city:(NSString*)city EmployType:(NSString*)EmployType Salary:(NSString*)Salary WorkYear:(NSString*)WorkYear SearchKey:(NSString*)SearchKey PositonType:(NSString*)PositonType WorkYearMin:(NSString *)WorkYearMin WorkYearMax:(NSString *)WorkYearMax Degree:(NSString*)Degree;


//判断是否做过测评
-(RACSignal *)isExamWithTokenId:(NSString *)tokenId userId:(NSString *)userId;

/** 名企推荐的数据 */
- (RACSignal *)getEnterprisesRecruitmentListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;
/** 猜你喜欢的数据 */
- (RACSignal *)guessYouLikePositionListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;

/**
 * 获取热门搜索关键字列表
 * @param pageSize(默认10，不传也行)
 * @return
 */
- (RACSignal *)getHotSearchKeyListWithPageSize:(NSInteger) PageSize;
/**
 * 获取搜索关键字列表
 * @param pageSize(默认10，不传也行)
 * @param searchKey
 * @return
 */
- (RACSignal *)getMartchSearchKeyListWithPageSize:(NSInteger) PageSize searchKey:(NSString*)searchKey;

/**
 *获取搜索框默认搜索关键字
 @param searcHKey
 *
 */
-(RACSignal *)getSearchDefaultKey;

/**
 *  猜你喜欢数据少于2条时的补数据接口
 *
 */
- (RACSignal *)getKeywordSearchPositionListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize city:(NSString *)city;
/**
 *  获取默认简历
 */
- (RACSignal *)getDefaultResumeInfoWithTokenId:(NSString *)tokenId userId:(NSString *)userId;

/**
 *  职位推荐接口
 */
- (RACSignal *)getJobRecommendWithTokenId:(NSString *)tokenId userId:(NSString *)userId pageSize:(NSInteger)PageSize pageIndex:(NSInteger)PageIndex;

// 检测版本更新
-(RACSignal *)getVersionWithType:(NSString *)type version:(NSString *)version;
@end
