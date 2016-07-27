//
//  RTNetworking+Company.m
//  cepin
//
//  Created by peng on 14-11-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking+Company.h"

@implementation RTNetworking (Company)

// 3.6.1关注企业列表
-(RACSignal *)getCompanyFocusListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    return [self.httpManager rac_GET:@"Company/FocusList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
    
}
// 3.6.2公司详情接口
-(RACSignal *)getCompanyDetailWithCustomerId:(NSString *)customerId UserId:(NSString *)UserId
{
    if ( !UserId )
    {
        return [self.httpManager rac_GET:@"Company/Detail" parameters:@{@"customerId":customerId}];
    }
    else
    {
        return [self.httpManager rac_GET:@"Company/Detail" parameters:@{@"customerId":customerId,@"UserId":UserId}];
    }
    
}

//  3.6.3公司收藏接口
-(RACSignal *)companyCollectWithCustomerId:(NSString *)customerId UserId:(NSString *)UserId
{
    return [self.httpManager rac_POST:@"Company/Collect" parameters:@{@"customerId":customerId,@"UserId":UserId}];
}

// 3.6.4公司取消收藏接口
-(RACSignal *)companyCancelCollectWithCustomerId:(NSString *)customerId UserId:(NSString *)UserId
{
    return [self.httpManager rac_POST:@"Company/CancelCollect" parameters:@{@"customerId":customerId,@"UserId":UserId}];
}
// 3.6.5 公司取消多个收藏接口
-(RACSignal *)companyBatchCancelCollectWithCustomerIds:(NSString *)customerIds UserId:(NSString *)UserId
{
    return [self.httpManager rac_POST:@"Company/BatchCancelCollect" parameters:@{@"customerIds":customerIds,@"UserId":UserId}];
}

// 3.6.6公司职位接口
-(RACSignal *)getCompanyPositionListWithTokenId:(NSString *)tokenId userId:(NSString *)userId customerId:(NSString *)customerId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    return [self.httpManager rac_POST:@"Company/PositionList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"customerId":customerId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
}

//3.6.7公司宣讲会接口
-(RACSignal *)getCompanyCampusFairListWithTokenId:(NSString *)tokenId userId:(NSString *)userId customerId:(NSString *)customerId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    return [self.httpManager rac_POST:@"Company/CampusFairList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"customerId":customerId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
}

//获取看过过我的简历的公司列表
-(RACSignal *)getViewedResumeListWithTokenId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString *)resumeId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize{
    return [self.httpManager rac_GET:@"ThridEdition/Resume/GetViewedResumeCustomerList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"resumeId":resumeId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
}
@end
