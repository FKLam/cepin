//
//  RTNetworking+Banner.m
//  cepin
//
//  Created by peng on 14-11-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking+Banner.h"

@implementation RTNetworking (Banner)

// 3.10.0  获取职业指南的更新状态
-(RACSignal *)getProfessionGuideIsNewNewsrWithUUID:(NSString *)UUID
{
    return [self.httpManager rac_GET:@"News/IsNewNews" parameters:@{@"UUID":UUID}];
}

// 3.10.1  职业指南首页
-(RACSignal *)getProfessionGuideFirstPage
{
    return [self.httpManager rac_GET:@"News/GetBanner" parameters:nil];
    
}

// 3.10.2  职业指南文章列表
-(RACSignal *)getProfessionGuideArticleListWithNewsTypeName:(NSString *)newsTypeName key:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    return [self.httpManager rac_GET:@"News/GetList" parameters:@{@"UUID":UUID_KEY,@"newsTypeName":newsTypeName,@"key":key,@"pageIndex":[NSString stringWithFormat:@"%d",(int)pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",(int)pageSize]}];
    
}

// 3.10.3  职业指南文章详情
-(RACSignal *)getProfessionGuideArticleDetailWithNewsId:(NSString *)newsId
{
    return [self.httpManager rac_GET:@"News/Get" parameters:@{@"newsId":newsId}];
    
}

// 3.10.4  问答列表
-(RACSignal *)getAnswerAndAskListWithType:(NSInteger)type key:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    return [self.httpManager rac_GET:@"News/GetAskList" parameters:@{@"type":[NSString stringWithFormat:@"%d",(int)type],@"key":key,@"pageIndex":[NSString stringWithFormat:@"%d",(int)pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",(int)pageSize]}];
    
}

// 3.10.5  问题详情
-(RACSignal *)getAskDetailWithAskId:(NSString *)askId
{
    return [self.httpManager rac_GET:@"News/GetAsk" parameters:@{@"askId":askId}];
    
}

// 3.10.6  添加问题
-(RACSignal *)updateAddAskWithTokenId:(NSString *)tokenId userId:(NSString *)userId title:(NSString *)title content:(NSString *)content
{
    return [self.httpManager rac_POST:@"News/AddAsk" parameters:@{@"tokenId":tokenId,@"userId":userId,@"title":title,@"content":content}];
    
}

// 3.10.7  评论列表
-(RACSignal *)getCommentListWithNewsId:(NSString *)newsId commentId:(NSString *)commentId isNew:(int)isNew pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    return [self.httpManager rac_GET:@"News/GetCommentList" parameters:@{@"newsId":newsId,@"commentId":commentId,@"isNew":@(isNew),@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)}];
    
}

// 3.10.8  发表评论
-(RACSignal *)updataAddCommentWithTokenId:(NSString *)tokenId userId:(NSString *)userId content:(NSString *)content newsId:(NSString *)newsId parentId:(NSString *)parentId replyCommentId:(NSString *)replyCommentId replyUserId:(NSString *)replyUserId
{
    return [self.httpManager rac_POST:@"News/AddComment" parameters:@{@"tokenId":tokenId,@"userId":userId,@"content":content,@"newsId":newsId,@"parentId":parentId,@"replyCommentId":replyCommentId,@"replyUserId":replyUserId}];
    
}

// 3.10.9  我的评论列表
-(RACSignal *)getMyCommentListWithTokenId:(NSString *)tokenId userId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    return [self.httpManager rac_GET:@"News/GetMyCommentList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"pageIndex":[NSString stringWithFormat:@"%d",(int)pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",(int)pageSize]}];
    
}

// 3.10.10  评论回复列表
-(RACSignal *)getMyCommentReplyListWithParentId:(NSString *)parentId commentId:(NSString *)commentId isNew:(BOOL)isNew pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    return [self.httpManager rac_GET:@"News/GetCommentReplyList" parameters:@{@"parentId":parentId,@"commentId":commentId,@"isNew":[NSString stringWithFormat:@"%d",isNew],@"pageIndex":[NSString stringWithFormat:@"%d",(int)pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",(int)pageSize]}];
    
}

// 3.10.11  获取评论
-(RACSignal *)getCommentWithParentId:(NSString *)parentId commentId:(NSString *)commentId
{
    return [self.httpManager rac_GET:@"News/GetComment" parameters:@{@"parentId":parentId,@"commentId":commentId}];
    
}

// 3.10.12  删除评论
-(RACSignal *)deleteCommentWithTokenId:(NSString *)tokenId userId:(NSString *)userId commentIds:(NSString *)commentIds
{
    return [self.httpManager rac_POST:@"News/DeleteComment" parameters:@{@"tokenId":tokenId,@"userId":userId,@"commentIds":commentIds}];
    
}

// 3.10.13  问答评论列表
-(RACSignal *)getAskCommentListWithAskId:(NSString *)askId commentId:(NSString *)commentId isNew:(BOOL)isNew pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    return [self.httpManager rac_GET:@"News/GetAskCommentList" parameters:@{@"askId":askId,@"commentId":commentId,@"isNew":[NSString stringWithFormat:@"%d",isNew],@"pageIndex":[NSString stringWithFormat:@"%d",(int)pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",(int)pageSize]}];
    
}

// 3.10.14  问答回复
-(RACSignal *)addAskCommentWithTokenId:(NSString *)tokenId userId:(NSString *)userId content:(NSString *)content askId:(NSString *)askId parentId:(NSString *)parentId replyUserId:(NSString *)replyUserId
{
    return [self.httpManager rac_POST:@"News/AddAskComment" parameters:@{@"tokenId":tokenId,@"userId":userId,@"content":content,@"askId":askId,@"parentId":parentId,@"replyUserId":replyUserId}];
    
}

// 3.10.15  我的问答列表
-(RACSignal *)getMyAskListWithTokenId:(NSString *)tokenId userId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    return [self.httpManager rac_GET:@"News/GetMyAskList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"pageIndex":[NSString stringWithFormat:@"%d",(int)pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",(int)pageSize]}];
    
}

// 3.10.16  问答评论回复列表
-(RACSignal *)getAskCommentReplyListWithParentId:(NSString *)parentId commentId:(NSString *)commentId isNew:(BOOL)isNew pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    return [self.httpManager rac_GET:@"News/GetAskCommentReplyList" parameters:@{@"parentId":parentId,@"commentId":commentId,@"isNew":[NSString stringWithFormat:@"%d",isNew],@"pageIndex":[NSString stringWithFormat:@"%d",(int)pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",(int)pageSize]}];
    
}

// 3.10.17  获取问答评论
-(RACSignal *)getAskCommentWithParentId:(NSString *)parentId commentId:(NSString *)commentId
{
    return [self.httpManager rac_GET:@"News/GetAskComment" parameters:@{@"parentId":parentId,@"commentId":commentId}];
    
}

// 3.10.18  删除问答
-(RACSignal *)deleteAskWithTokenId:(NSString *)tokenId userId:(NSString *)userId askIds:(NSString *)askIds
{
    return [self.httpManager rac_POST:@"News/DeleteAsk" parameters:@{@"tokenId":tokenId,@"userId":userId,@"askIds":askIds}];
    
}

// 3.10.19  删除问答评论
-(RACSignal *)deleteAskCommentWithTokenId:(NSString *)tokenId userId:(NSString *)userId commentIds:(NSString *)commentIds
{
    return [self.httpManager rac_POST:@"News/DeleteAskComment" parameters:@{@"tokenId":tokenId,@"userId":userId,@"commentIds":commentIds}];
    
}

// 3.10.20  我的问答评论列表
-(RACSignal *)getMyAskCommentListWithTokenId:(NSString *)tokenId userId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    return [self.httpManager rac_GET:@"News/GetMyAskCommentList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"pageIndex":[NSString stringWithFormat:@"%d",(int)pageIndex],@"pageSize":[NSString stringWithFormat:@"%d",(int)pageSize]}];
    
}


-(RACSignal *)getBanner:(int)type
{
    return [self.httpManager rac_GET:@"Common/GetAdvertisementList" parameters:@{@"type":[NSString stringWithFormat:@"%d",type]}];
}

@end
