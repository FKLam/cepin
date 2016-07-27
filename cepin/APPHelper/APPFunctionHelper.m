//
//  APPFunctionHelper.m
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "APPFunctionHelper.h"
@implementation APPFunctionHelper
+(BOOL)checkValidUserTokenId
{
    if ([[MemoryCacheData shareInstance]userId] && [[MemoryCacheData shareInstance]userTokenId])
    {
        return YES;
    }
    return NO;
}
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}
+(int)computerOffsetY:(int)offset topRect:(CGRect)rect
{
    return rect.size.height + rect.origin.y + offset;
}
//检查邮箱是否正确
+(BOOL)checkEmailText:(NSString*)checkText
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkText];
}
//检查手机号码是否正确
+(BOOL)checkPhoneText:(NSString*)phoneText
{
    NSString *phoneRegex = @"^1[3,4,5,7,8]{1}\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneText];
}
// 检查QQ号码是否正确
+ (BOOL)checkQQText:(NSString *)QQText
{
    NSString *qqRegex = @"^[1-9](\\d){4,9}$";
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qqRegex];
    return [qqTest evaluateWithObject:QQText];
}
// 检查邮政编码是否正确
+ (BOOL)checkCodeText:(NSString *)codeText
{
    NSString *codeRegex = @"^[1-9](\\d){5}$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:codeText];
}
// 验证手机号码和固话
+ (BOOL)checkMobileAndPhoneText:(NSString *)mobileNum
{
    /**
     
     * 手机号码
     
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     * 联通：130,131,132,152,155,156,185,186
     
     * 电信：133,1349,153,180,189
     
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     
     10         * 中国移动：China Mobile
     
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     12         */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     
     15         * 中国联通：China Unicom
     
     16         * 130,131,132,152,155,156,185,186
     
     17         */
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     
     20         * 中国电信：China Telecom
     
     21         * 133,1349,153,180,189
     
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     
     25         * 大陆地区固话及小灵通
     
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     
     27         * 号码：七位或八位
     
     28         */
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       
       || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//判断是否含有特殊字符;
+(BOOL)checkIsVailidCharactor:(NSString*)checkString
{
    //NSString *phoneRegex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5_]+";
    NSString *phoneRegex = @"^\\w{1,9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isTrue = [phoneTest evaluateWithObject:checkString];
    return isTrue;
}
// 验证身份证号合法性
+ (BOOL)checkIdentityCard:(NSString *)identityCard
{
//    BOOL flag;
//    if ( identityCard.length <= 0 ) {
//        flag = NO;
//        return flag;
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:identityCard];
    return [self checkIdentityCardNo:identityCard];
}
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}
@end
