//
//  RTNetworking+Position.m
//  cepin
//
//  Created by peng on 14-11-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking+Position.h"

@implementation RTNetworking (Position)

// 3.7.1职位收藏列表
-(RACSignal *)getPositionCollectionListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    return [self.httpManager rac_GET:@"Position/CollectionList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
}
// 3.7.2职位详情接口
-(RACSignal *)getPositionDetailWithTokenId:(NSString *)tokenId userId:(NSString *)userId positionId:(NSString *)positionId
{
    if ( !tokenId || !userId )
    {
        return [self.httpManager rac_GET:@"Position/Detail" parameters:@{@"positionId":positionId}];
    }
    else
    {
        return [self.httpManager rac_GET:@"Position/Detail" parameters:@{@"tokenId":tokenId,@"userId":userId,@"positionId":positionId}];
    }
}
// 3.7.3职位收藏接口
-(RACSignal *)positionCollectWithUserId:(NSString *)UserId positionId:(NSString *)positionId
{
    return [self.httpManager rac_POST:@"Position/Collect" parameters:@{@"UserId":UserId,@"positionId":positionId}];
}
// 3.7.4职位取消收藏接口
-(RACSignal *)positionCancelCollectWithUserId:(NSString *)UserId positionId:(NSString *)positionId
{
    return [self.httpManager rac_POST:@"Position/CancelCollect" parameters:@{@"UserId":UserId,@"positionId":positionId}];
}
// 3.7.5 职位取消多个收藏接口
-(RACSignal *)positionBatchCancelCollectWithUserId:(NSString *)UserId positionIds:(NSString *)positionIds
{
    return [self.httpManager rac_POST:@"Position/BatchCancelCollect" parameters:@{@"UserId":UserId,@"positionIds":positionIds}];
    
}

// 3.7.6职位搜索接口
-(RACSignal *)getPositionSeachWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize Key:(NSString *)Key t:(NSInteger)t city:(NSString*)city nature:(NSString*)nature salary:(NSString*)salary
{
    return [[self.httpManager rac_POST:@"Position/Search_ForThird" parameters:@{@"tokenId":tokenId,@"userId":userId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize),@"Key":Key,@"t":@(t),@"city":city,@"Salary":salary,@"Nature":nature}]logAll];
    
}

// 3.7.7职位筛选搜索
-(RACSignal *)getPositionFilterWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize city:(NSString *)city Nature:(NSInteger)Nature Salary:(NSString *)Salary
{
    return [self.httpManager rac_POST:@"Position/Search" parameters:@{@"tokenId":tokenId,@"userId":userId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize),@"city":city,@"Nature":@(Nature),@"Salary":Salary}];
    
}


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
-(RACSignal *)getPositionSeachWithJobFunction:(NSString *)jobFunction EmployType:(NSString *)employType SalaryMin:(NSInteger)salaryMin SalaryMax:(NSInteger)salaryMax SearchKey:(NSString *)searchKey city:(NSString*)city WorkYear:(NSString*)workYear
{
     return [[self.httpManager rac_POST:@"/Position/Search_ForThird" parameters:@{@"JobFunction":jobFunction,@"EmployType":employType,@"SalaryMin":@(salaryMin),@"SalaryMax":@(salaryMax),@"SearchKey":searchKey,@"city":city,@"WorkYear":workYear}]logAll];
}
//相似职位
-(RACSignal *)positionSimilarityWithSize:(NSInteger)size positionIds:(NSString *)positionIds tokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_GET:@"/ThridEdition/Position/SmairlPositionList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"size":@(size),@"positionId":positionIds}];
}
//首页推荐
-(RACSignal *)getPositionWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize City:(NSString *)city
{
    if( nil != tokenId && nil != userId && 0 != tokenId.length && 0 != userId.length )
    {
        // 猜你喜欢的数据
        return [self.httpManager rac_GET:@"/ThridEdition/Position/ExpectPositionList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
    }
    else
    {
        NSDate *date=[NSDate date];
        NSDate *newDate =  [self getPriousorLaterDateFromDate:date withMonth:-1];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYYMMdd"];
        NSString *locationString=[dateformatter stringFromDate:newDate];
        return [self.httpManager rac_GET:@"/Position/Search_ForThird" parameters:@{@"PageIndex":@(PageIndex),@"PageSize":@(PageSize),@"City":city,@"SearchKey":@"",@"PublishDate":locationString}];
        // 最新发布的数据
//        return [self.httpManager rac_GET:@"/ThridEdition/Position/CustomRecommendPoisitionList" parameters:@{@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
    }
}

// 检测版本更新
- (RACSignal *)getVersionWithType:(NSString *)type version:(NSString *)version
{
    return [self.httpManager rac_GET:@"/ThridEdition/Common/GetNewestAppVersion" parameters:@{@"type" : type}];
}
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}

///ThridEdition/Position/GuessYouLikePositionList
- (RACSignal *)guessYouLikePositionListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    // 猜你喜欢的数据
    return [self.httpManager rac_GET:@"/ThridEdition/Position/GuessYouLikePositionList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
}
///ThridEdition/Position/GetKeywordSearchPositionList
- (RACSignal *)getKeywordSearchPositionListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize city:(NSString *)city
{
    // 补猜你喜欢的数据
    return [self.httpManager rac_GET:@"/ThridEdition/Position/GetKeywordSearchPositionList" parameters:@{@"tokenId" : tokenId, @"userId" : userId, @"PageIndex" : @(PageIndex), @"size" : @(PageSize), @"city" : city}];
}
///ThridEdition/Common/GetEnterprisesRecruitmentList
- (RACSignal *)getEnterprisesRecruitmentListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    // 名企推荐的数据
    return [self.httpManager rac_GET:@"/ThridEdition/position/GetEnterprisesRecruitmentList" parameters:@{@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
}
///ThridEdition/Resume/GetDefaultResumeInfo
- (RACSignal *)getDefaultResumeInfoWithTokenId:(NSString *)tokenId userId:(NSString *)userId
{
    // 返回默认简历
    return [self.httpManager rac_GET:@"/ThridEdition/Resume/GetDefaultResumeInfo" parameters:@{ @"tokenId" : tokenId, @"userId" : userId} ];
}
//3.0职位搜索
-(RACSignal *)getPositionSeachWithPageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize JobFunction:(NSString *)JobFunction city:(NSString *)city EmployType:(NSString *)EmployType Salary:(NSString *)Salary WorkYear:(NSString *)WorkYear SearchKey:(NSString *)SearchKey PositonType:(NSString*)PositonType
{
    return [self.httpManager rac_GET:@"/Position/Search_ForThird" parameters:@{@"JobFunction":JobFunction,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize),@"city":city,@"EmployType":EmployType,@"Salary":Salary,@"WorkYear":WorkYear,@"SearchKey":SearchKey,@"PositionType":PositonType}];
}

//3.2搜索 工作年限改为区间的方式传入
-(RACSignal *)getPositionSeachWithPageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize JobFunction:(NSString *)JobFunction city:(NSString *)city EmployType:(NSString *)EmployType Salary:(NSString *)Salary WorkYear:(NSString *)WorkYear SearchKey:(NSString *)SearchKey PositonType:(NSString*)PositonType WorkYearMin:(NSString *)WorkYearMin WorkYearMax:(NSString *)WorkYearMax Degree:(NSString *)Degree
{
    return [self.httpManager rac_GET:@"/Position/Search_ForThird" parameters:@{@"JobFunction":JobFunction,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize),@"city":city,@"EmployType":EmployType,@"Salary":Salary,@"WorkYear":WorkYear,@"SearchKey":SearchKey,@"PositionType":PositonType,@"WorkYearMin":WorkYearMin,@"WorkYearMax":WorkYearMax ,@"Degree":Degree}];
}
//判断是否做过测评
-(RACSignal *)isExamWithTokenId:(NSString *)tokenId userId:(NSString *)userId
{
       return [self.httpManager rac_GET:@"/ThridEdition/User/IsOpenSpeedExam" parameters:@{@"tokenId":tokenId,@"userId":userId}];
}

-(RACSignal *)getHotSearchKeyListWithPageSize:(NSInteger)PageSize{
    return [self.httpManager rac_GET:@"/ThridEdition/Common/GetHotSearchKeyList" parameters:@{@"PageSize":@(PageSize)}];
}


-(RACSignal *)getMartchSearchKeyListWithPageSize:(NSInteger)PageSize searchKey:(NSString *)searchKey{
    return [self.httpManager rac_GET:@"/ThridEdition/Common/GetPositionSearchWordList" parameters:@{@"PageSize":@(PageSize),@"searchKey":searchKey}];
}


-(RACSignal *)getSearchDefaultKey{
    return [self.httpManager rac_GET:@"/ThridEdition/Common/GetTextCodeList" parameters:@{@"codeType":@(3),@"parentId":@""}];
    
}


-(RACSignal *)getJobRecommendWithTokenId:(NSString *)tokenId userId:(NSString *)userId pageSize:(NSInteger)PageSize pageIndex:(NSInteger)PageIndex{

    return [self.httpManager rac_GET:@"/Thridedition/User/GetJobRecommend" parameters:@{@"tokenId":tokenId,@"userId":userId,@"pageSize":@(PageSize),@"pageIndex":@(PageIndex)}];

}

@end
