//
//  RTNetworking+Chat.m
//  cepin
//
//  Created by peng on 14-11-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking+Chat.h"

@implementation RTNetworking (Chat)

// 3.4.4获得融云tokenId接口

-(RACSignal *)getRongcloudTokenWithTokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_POST:@"Rongcloud/GetToken" parameters:@{@"tokenId":tokenId,@"userId":userId}];
    
}

-(RACSignal *)saveChatJobInfo:(NSDictionary*)dic
{
    return [self.httpManager rac_POST:@"Rongcloud/SavePosition" parameters:dic];
}
-(RACSignal *)getChatJobInfo:(NSDictionary*)dic
{
    return [self.httpManager rac_POST:@"Rongcloud/GetPosition" parameters:dic];
}

@end
