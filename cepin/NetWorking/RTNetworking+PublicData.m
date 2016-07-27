//
//  RTNetworking+PublicData.m
//  cepin
//
//  Created by peng on 14-11-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking+PublicData.h"

@implementation RTNetworking (PublicData)

//3.2.1  查询基础数据是否有更新
-(RACSignal *)queryUpdataDBWithVersion:(NSString *)version
{
    return [self.httpManager rac_GET:@"Common/UpdateDB" parameters:@{@"version":version}];
}

//3.2.2  收藏及关注数量接口
-(RACSignal *)queryCollectionCountWithTokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_POST:@"User/CollectionCount" parameters:@{@"tokenId":tokenId,@"userId":userId}];
}

//3.2.3  收藏及关注状态改变接口
-(RACSignal *)queryCollectionStatusWithTokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_POST:@"Common/CollectionStatus" parameters:@{@"tokenId":tokenId,@"userId":userId}];
}

//3.2.3  未完成测评状态改变接口
-(RACSignal *)GetUnExamsCountWithTokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_GET:@"/ThridEdition/User/GetUnExamsCount" parameters:@{@"tokenId":tokenId,@"userId":userId}];
}


// 3.2.4  App启动后时接口
-(RACSignal *)openAppWithUUID:(NSString *)UUID openRefer:(NSString *)openRefer
{
    return [self.httpManager rac_POST:@"Common/OpenApp" parameters:@{@"UUID":UUID,@"openRefer":openRefer}];
    
}

// 3.2.5  点击探索时同时调用该接口
-(RACSignal *)upDataNewsTimeWithUUID:(NSString *)UUID userId:(NSString *)userId
{
    return [self.httpManager rac_POST:@"Common/UpdateNewsTime" parameters:@{@"UUID":UUID,@"userId":userId}];
    
}
// 3.2.6  获取热门城市数据接口
-(RACSignal *)getHotCityData
{
    return [self.httpManager rac_GET:@"ThridEdition/Common/GetHotRegionList" parameters:NULL];
}
// 3.2 获取个人中心信息
-(RACSignal *)getUnOperationCountWithUserId:(NSString *)userId
{
    return [self.httpManager rac_POST:@"Common/GetUnOperatorCount" parameters:@{@"userId":userId}];
}
@end
