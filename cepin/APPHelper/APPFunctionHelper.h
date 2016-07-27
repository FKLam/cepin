//
//  APPFunctionHelper.h
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPFunctionHelper : NSObject

+(BOOL)checkValidUserTokenId;
//提取html标签字符串
+(NSString *)filterHTML:(NSString *)html;
//计算相对于上一个视图的纵向位置
+(int)computerOffsetY:(int)offset topRect:(CGRect)rect;
 //检查邮箱是否正确
+(BOOL)checkEmailText:(NSString*)checkText;
//检查手机号码是否正确
+(BOOL)checkPhoneText:(NSString*)phoneText;
//判断是否含有特殊字符;
+(BOOL)checkIsVailidCharactor:(NSString*)checkString;
// 验证身份证号合法性
+ (BOOL)checkIdentityCard:(NSString *)identityCard;
// 检查QQ号码是否正确
+ (BOOL)checkQQText:(NSString *)QQText;
// 检查邮政编码是否正确
+ (BOOL)checkCodeText:(NSString *)codeText;
// 验证手机号码和固话
+ (BOOL)checkMobileAndPhoneText:(NSString *)mobileNum;
@end
