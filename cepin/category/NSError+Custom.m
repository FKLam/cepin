//
//  NSError+Custom.m
//  letsgo
//
//  Created by Ricky Tang on 14-8-6.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "NSError+Custom.h"

NSString *const ErrorKey = @"ErrorKey";

@implementation NSError (Custom)
+(NSError *)errorWithErrorType:(ErrorType)type
{
    NSDictionary *dic = nil;
    //    NSString *domain = nil;
    
    switch (type) {
        case ErrorTypeMobile:
        {
            dic = @{ErrorKey: NSLocalizedString(@"电话号码不正确",nil)};
        }
            break;
        case ErrorTypeEmail:
        {
            dic = @{ErrorKey: NSLocalizedString(@"输入的不是电子邮箱",nil)};
        }
            break;
        case ErrorTypeMobileNotSiginUp:
            dic = @{ErrorKey: NSLocalizedString(@"电话号码没有注册过", nil)};
            break;
        case ErrorTypeMobileSiginUp:
            dic = @{ErrorKey: NSLocalizedString(@"电话号码已经注册过", nil)};
            break;
        case ErrorTypeCheckCode:
        {
            dic = @{ErrorKey: NSLocalizedString(@"验证码不正确",nil)};
        }
            break;
        case ErrorTypePassword:
        {
            dic = @{ErrorKey: NSLocalizedString(@"密码不正确",nil)};
        }
            break;
        case ErrorTypeLost:
        {
            dic = @{ErrorKey: NSLocalizedString(@"数据提交失败",nil)};
        }
            break;
        case ErrorTypeAuthCode:
            dic = @{ErrorKey: NSLocalizedString(@"验证输入不正确",nil)};
            break;
        case ErrorTypeNoNet:
            dic = @{ErrorKey: NSLocalizedString(@"您的网络有问题",nil)};
            break;
        case ErrorTypeLocationLost:
            dic = @{ErrorKey: NSLocalizedString(@"没有获得坐标地址",nil)};
            break;
        default:
            break;
    }
    
    
    return [[NSError alloc] initWithDomain:@"" code:type userInfo:dic];
}
+(NSError *)errorWithErrorMessage:(NSString *)message
{
    return [[NSError alloc] initWithDomain:@"" code:3000 userInfo:@{ErrorKey:message}];
}
@end
