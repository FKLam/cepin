//
//  NSString+UserInfo.m
//  cepin
//
//  Created by ceping on 15-1-21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "NSString+UserInfo.h"


@implementation NSString (UserInfoAdditon)

-(BOOL)CheckUserInfoValid
{
    if (self.length <= 0 || [self isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}

//判断是否含有特殊字符;
-(BOOL)checkIsVailidCharactor
{
    NSString *phoneRegex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5_]+";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

//检查邮箱是否正确
-(BOOL)checkEmailValid
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//检查手机号码是否正确
-(BOOL)checkPhoneValid
{
    NSString *phoneRegex = @"^1[3,4,5,7,8]{1}\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

-(BOOL)CheckNickName:(NSString**)error
{
    if (![self CheckUserInfoValid])
    {
        *error = @"请输入昵称";
        return NO;
    }
    else if(![self checkIsVailidCharactor])
    {
        *error = @"昵称格式不正确";
        return NO;
    }
    else
    {
        return YES;
    }
}
-(BOOL)CheckMobie:(NSString**)error
{
    if (![self CheckUserInfoValid])
    {
        *error = @"请输入手机号码";
        return NO;
    }
    else if(![self checkPhoneValid])
    {
        *error = @"手机号码不正确";
        return NO;
    }
    else
    {
        return YES;
    }
}
-(BOOL)CheckEmail:(NSString**)error
{
    if (![self CheckUserInfoValid])
    {
        *error = @"请输入邮箱";
        return NO;
    }
    else if(![self checkEmailValid])
    {
        *error = @"邮箱格式不正确";
        return NO;
    }
    else
    {
        return YES;
    }
}
-(BOOL)CheckSignature:(NSString**)error
{
    if (![self CheckUserInfoValid])
    {
        *error = @"请输入个性签名";
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
