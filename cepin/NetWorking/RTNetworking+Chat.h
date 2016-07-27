//
//  RTNetworking+Chat.h
//  cepin
//
//  Created by peng on 14-11-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking.h"

@interface RTNetworking (Chat)

/**

 
 3.4.1添加朋友接口（暂时不做）

 
 */

/**


3.4.2删除朋友接口（暂时不做）


*/

/**


3.4.3朋友列表接口（暂时不做）


*/

/**
3.4.4获得融云tokenId接口
 URL
http://app2.cepin.com/Rongcloud/GetToken
 HTTP请求
 POST
 请求参数 tokenId  String
         userId   guid
*/

-(RACSignal *)getRongcloudTokenWithTokenId:(NSString *)tokenId userId:(NSString *)userId;
-(RACSignal *)saveChatJobInfo:(NSDictionary*)dic;
-(RACSignal *)getChatJobInfo:(NSDictionary*)dic;


@end
