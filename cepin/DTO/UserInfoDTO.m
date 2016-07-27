//
//  UserInfoDTO.m
//  cepin
//
//  Created by tassel.li on 14-10-9.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UserInfoDTO.h"
#import "FileManagerHelper.h"

@implementation UserInfoDTO
/*
+(UserInfoDTO *)userInfoWithDictionary:(NSDictionary *)dic folder:(NSString*)folder
{
    NSError *error = nil;
    UserInfoDTO *info = [[UserInfoDTO alloc] initWithDictionary:dic error:&error];
    
    NSAssert(error == nil, @"UserInfo fail");
    
    //保存本地
    [FileManagerHelper writeObject:info file:NSStringFromClass([UserInfoDTO class]) folder:[[NSUserDefaults standardUserDefaults]objectForKey:@"userAccout"] sandBoxFolder:kUseDocumentTypeLibraryCaches];
    
    return info;
}

+(UserInfoDTO *)OtherUserInfo:(NSDictionary *)dic
{
    NSError *error = nil;
    UserInfoDTO *info = [[UserInfoDTO alloc] initWithDictionary:dic error:&error];
    
    NSAssert(error == nil, @"UserInfo fail");
    return info;
}

+(UserInfoDTO *)info:(NSString*)folder
{
    return [FileManagerHelper readObjectWithfile:NSStringFromClass([UserInfoDTO class]) folder:[[NSUserDefaults standardUserDefaults]objectForKey:@"userAccout"] sandBoxFolder:kUseDocumentTypeLibraryCaches];
}
*/

-(void)checkValid
{
    self.UserName = self.UserName?self.UserName:@"";
    self.Mobile = self.Mobile?self.Mobile:@"";
    self.Email = self.Email?self.Email:@"";
    self.PersonalitySignature = self.PersonalitySignature?self.PersonalitySignature:@"";
}

@end
