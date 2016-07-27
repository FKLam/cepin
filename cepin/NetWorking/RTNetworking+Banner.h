//
//  RTNetworking+Banner.h
//  cepin
//
//  Created by peng on 14-11-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking.h"

@interface RTNetworking (Banner)

/**
 *  接口说明
 3.10.0  获取职业指南的更新状态
 URL
 http://app.cepin.com/News/IsNewNewsr
 
 HTTP请求方式
 GET
 */

-(RACSignal *)getProfessionGuideIsNewNewsrWithUUID:(NSString *)UUID;


/**
 *  接口说明
 3.10.1  职业指南首页
 URL
 http://app2.cepin.com/News/GetBanner
 
 HTTP请求方式
 GET
 */

-(RACSignal *)getProfessionGuideFirstPage;



/**
 *  接口说明
 3.10.2  职业指南文章列表
 URL
 http://app2.cepin.com/News/GetList
 
 HTTP请求方式
 GET
 */

-(RACSignal *)getProfessionGuideArticleListWithNewsTypeName:(NSString *)newsTypeName key:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;


/**
 *  接口说明
 3.10.3  职业指南文章详情
 URL
 http://app2.cepin.com/News/Get
 
 HTTP请求方式
 GET

 */

-(RACSignal *)getProfessionGuideArticleDetailWithNewsId:(NSString *)newsId;


/**
 *  接口说明
 3.10.4  问答列表
 URL
 http://app2.cepin.com/News/GetAskList
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getAnswerAndAskListWithType:(NSInteger)type key:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;


/**
 *  接口说明
 3.10.5  问题详情
 URL
 http://app2.cepin.com/News/GetAsk
 HTTP请求方式
 GET

 */

-(RACSignal *)getAskDetailWithAskId:(NSString *)askId;


/**
 *  接口说明
 3.10.6  添加问题
 URL
 http://app2.cepin.com/News/AddAsk
 HTTP请求方式
 Post
 */

-(RACSignal *)updateAddAskWithTokenId:(NSString *)tokenId userId:(NSString *)userId title:(NSString *)title content:(NSString *)content;



/**
 *  接口说明
 3.10.7  评论列表
 URL
 http://app2.cepin.com/News/GetCommentList
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getCommentListWithNewsId:(NSString *)newsId commentId:(NSString *)commentId isNew:(int)isNew pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;



/**
 *  接口说明
 3.10.8  发表评论
 URL
 http://app2.cepin.com/News/AddComment
 HTTP请求方式
 Post
 
 */

-(RACSignal *)updataAddCommentWithTokenId:(NSString *)tokenId userId:(NSString *)userId content:(NSString *)content newsId:(NSString *)newsId parentId:(NSString *)parentId replyCommentId:(NSString *)replyCommentId replyUserId:(NSString *)replyUserId;

/**
 *  接口说明
 3.10.9  我的评论列表
 URL
 http://app2.cepin.com/News/GetMyCommentList
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getMyCommentListWithTokenId:(NSString *)tokenId userId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

/**
 *  接口说明
 3.10.10  评论回复列表
 URL
 http://app2.cepin.com/News/GetCommentReplyList
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getMyCommentReplyListWithParentId:(NSString *)parentId commentId:(NSString *)commentId isNew:(BOOL)isNew pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;
/**
 *  接口说明
 3.10.11  获取评论
 URL
 http://app2.cepin.com/News/GetComment
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getCommentWithParentId:(NSString *)parentId commentId:(NSString *)commentId;

/**
 *  接口说明
 3.10.12  删除评论
 URL
 http://app2.cepin.com/News/DeleteComment
 
 HTTP请求方式
 Post
 
 */

-(RACSignal *)deleteCommentWithTokenId:(NSString *)tokenId userId:(NSString *)userId commentIds:(NSString *)commentIds;

/**
 *  接口说明
 3.10.13  问答评论列表
 URL
 http://app2.cepin.com/News/GetAskCommentList
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getAskCommentListWithAskId:(NSString *)askId commentId:(NSString *)commentId isNew:(BOOL)isNew pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

/**
 *  接口说明
 3.10.14  问答回复
 URL
 http://app2.cepin.com/News/AddAskComment
 
 HTTP请求方式
 Post
 
 */

-(RACSignal *)addAskCommentWithTokenId:(NSString *)tokenId userId:(NSString *)userId content:(NSString *)content askId:(NSString *)askId parentId:(NSString *)parentId replyUserId:(NSString *)replyUserId;

/**
 *  接口说明
 3.10.15  我的问答列表
 URL
 http://app2.cepin.com/News/GetMyAskList
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getMyAskListWithTokenId:(NSString *)tokenId userId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

/**
 *  接口说明
 3.10.16  问答评论回复列表
 URL
 http://app2.cepin.com/News/GetAskCommentReplyList
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getAskCommentReplyListWithParentId:(NSString *)parentId commentId:(NSString *)commentId isNew:(BOOL)isNew pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

/**
 *  接口说明
 3.10.17  获取问答评论
 URL
 http://app2.cepin.com/News/GetAskComment
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getAskCommentWithParentId:(NSString *)parentId commentId:(NSString *)commentId;

/**
 *  接口说明
 3.10.18  删除问答
 URL
 http://app2.cepin.com/News/DeleteAsk
 
 HTTP请求方式
 Post
 
 */

-(RACSignal *)deleteAskWithTokenId:(NSString *)tokenId userId:(NSString *)userId askIds:(NSString *)askIds;


/**
 *  接口说明
 3.10.19  删除问答评论
 URL
 http://app2.cepin.com/News/DeleteAskComment
 
 HTTP请求方式
 Post
 
 */

-(RACSignal *)deleteAskCommentWithTokenId:(NSString *)tokenId userId:(NSString *)userId commentIds:(NSString *)commentIds;


/**
 *  接口说明
 3.10.20  我的问答评论列表
 URL
 http://app2.cepin.com/News/GetMyAskCommentList
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getMyAskCommentListWithTokenId:(NSString *)tokenId userId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;


/**
 *  接口说明
 3.10.20  获取广告
 URL
 http://app2.cepin.com/News/GetMyAskCommentList
 
 HTTP请求方式
 GET
 
 */

-(RACSignal *)getBanner:(int)type;


@end
