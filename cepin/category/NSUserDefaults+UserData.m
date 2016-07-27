//
//  NSUserDefaults+UserData.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-24.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "NSUserDefaults+UserData.h"

static NSString *const UserDataLoginRemanber = @"UserDataLoginRemanber";
static NSString *const UserDataLoginUserName = @"UserDataLoginUserName";
static NSString *const UserDataLoginUserID = @"UserDataLoginUserID";
static NSString *const UserDataLoginPhone = @"UserDataLoginPhone";
static NSString *const UserDataLoginPassword = @"UserDataLoginPassword";
static NSString *const UserDataUseTimes = @"UserDataUseTimes";
static NSString *const UserDataLoginToken = @"UserDataLoginToken";
static NSString *const AppVision = @"AppVision";
static NSString *const AppComment = @"AppComment";


@implementation NSUserDefaults (UserData)

-(BOOL)loginRemanber{
    return [self boolForKey:UserDataLoginRemanber];
}

-(void)setLoginRemanber:(BOOL)value
{
    [self setBool:value forKey:UserDataLoginRemanber];
}

-(NSString *)loginUserName{
    return [self stringForKey:UserDataLoginUserName];
}

-(void)setLoginUserName:(NSString *)value{
    [self setValue:value forKey:UserDataLoginUserName];
}

-(NSString *)loginUserID{
    return [self valueForKey:UserDataLoginUserID];
}

-(void)setLoginUserID:(NSString *)value
{
    [self setValue:value forKey:UserDataLoginUserID];
}


-(NSString *)loginPhoneNumber{
    return [self stringForKey:UserDataLoginPhone];
}

-(void)setLoginPhoneNumber:(NSString *)value{
    [self setValue:value forKey:UserDataLoginPhone];
}


-(NSString *)loginPassword
{
    return [self stringForKey:UserDataLoginPassword];
}

-(void)setLoginPassword:(NSString *)value
{
    [self setValue:value forKey:UserDataLoginPassword];
}


-(int64_t)useTimes
{
    return [[self valueForKey:UserDataUseTimes] longLongValue];
}

-(void)setUseTime:(int64_t)value
{
    [self setValue:[NSNumber numberWithLongLong:value] forKey:UserDataUseTimes];
}


-(NSString *)loginToken{
    return [self valueForKey:UserDataLoginToken];
}

-(void)setLoginToken:(NSString *)value
{
    [self setValue:value forKey:UserDataLoginToken];
}

-(NSString *)appVision
{
    return [self valueForKey:AppVision];
}

-(void)setAppVision:(NSString *)vision
{
    [self setValue:vision forKey:AppVision];
}

-(BOOL)appComment
{
    return [self boolForKey:AppComment];
}

-(void)setAppComment:(BOOL)isComment
{
    [self setBool:isComment forKey:AppComment];
}

@end
