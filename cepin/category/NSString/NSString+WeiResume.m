//
//  NSString+WeiResume.m
//  cepin
//
//  Created by ceping on 15-1-9.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "NSString+WeiResume.h"
#import "SchoolDTO.h"
#import "BaseCodeDTO.h"
#import "APPFunctionHelper.h"
@implementation NSString (WeiResumeAddtion)
// 验证身份证号合法性
- (BOOL)checkIdentityCard
{
    if (self.length <= 0 || [self isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}
- (BOOL)checkIdentityCard:(NSString **)error
{
    if ( ![self checkIdentityCard] )
    {
        *error = @"请输入身份证号";
        return NO;
    }
    if (![APPFunctionHelper checkIdentityCard:self])
    {
        *error = @"身份证号不合法";
        return NO;
    }
    return YES;
}
- (BOOL)CheckResumeValid
{
    if (self.length <= 0 || [self isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}
- (BOOL)CheckResumeName:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"请输入简历名称";
        return NO;
    }
    if (self.length > 16)
    {
        *error = @"简历名称不能超过16个字符";
        return NO;
    }
    return YES;
}
-(BOOL)CheckResumeChineseName:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"请输入姓名";
        return NO;
    }
    if (self.length > 16)
    {
        *error = @"姓名不能超过16个字符";
        return NO;
    }
    return YES;
}
-(BOOL)CheckResumeSchoolName:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"学校名称不能找到";
        return NO;
    }
    NSArray *array = [School schoolWithFullName:self];
    if (array && array.count > 0)
    {
        School *school = array[0];
        *error = school.SchoolId;
        return YES;
    }
    *error = @"学校名称不能找到";
    return NO;
}
-(BOOL)CheckResumeSchoolId:(NSString**)error
{
    NSArray *array = [School schoolWithFullName:self];
    if (array && array.count > 0)
    {
        School *school = array[0];
        *error = school.SchoolId;
        return YES;
    }
    *error = @"学校名称不能找到";
    return NO;
}
-(BOOL)CheckResumeMajorName:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"专业名称不能找到";
        return NO;
    }
    NSArray *array = [BaseCode majorWithFullName:self];
    if (array && array.count > 0)
    {
        BaseCode *code = array[0];
        *error = [NSString stringWithFormat:@"%d",code.CodeKey.intValue];
        return YES;
    }
    *error = @"专业名称不能找到";
    return NO;
}
-(BOOL)CheckResumeMajorKey:(NSString**)error
{
    NSArray *array = [BaseCode majorWithFullName:self];
    if (array && array.count > 0)
    {
        BaseCode *code = array[0];
        *error = [NSString stringWithFormat:@"%d",code.CodeKey.intValue];
        return YES;
    }
    *error = @"专业名称不能找到";
    return NO;
}
-(BOOL)CheckResumeDegreeKey:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"请选择学历";
        return NO;
    }
    NSArray *array = [BaseCode DegreeWithFullName:self];
    if (array && array.count > 0)
    {
        BaseCode *code = array[0];
        *error = [NSString stringWithFormat:@"%d",code.CodeKey.intValue];
        return YES;
    }
    *error = @"学历不能找到";
    
    return NO;
}
-(BOOL)CheckResumeUserRemarkName:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"自我评价不能为空";
        return NO;
    }
    return YES;
}
-(BOOL)CheckResumePhone:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"请输入手机号码";
        return NO;
    }
    if (![APPFunctionHelper checkPhoneText:self])
    {
        *error = @"手机号码格式不正确";
        return NO;
    }
    return YES;
}
- (BOOL)checkResumeQQ:(NSString **)error
{
    if ( ![self CheckResumeValid] )
    {
        *error = @"请输入QQ号码";
        return NO;
    }
    if ( ![APPFunctionHelper checkQQText:self] )
    {
        *error = @"QQ号码格式不正确";
        return NO;
    }
    return YES;
}
- (BOOL)checkResumeCode:(NSString **)error
{
    if ( ![self CheckResumeValid] )
    {
        *error = @"请输入邮政编码";
        return NO;
    }
    if ( ![APPFunctionHelper checkCodeText:self] )
    {
        *error = @"邮政编码格式不正确";
        return NO;
    }
    return YES;
}
- (BOOL)checkResumeContact:(NSString **)error
{
    if ( ![self CheckResumeValid] )
    {
        *error = @"请输入紧急联系人方式";
        return NO;
    }
    if ( ![APPFunctionHelper checkMobileAndPhoneText:self] )
    {
        *error = @"紧急联系人方式格式不正确";
        return NO;
    }
    return YES;
}
-(BOOL)CheckResumeEmail:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"请输入邮箱";
        return NO;
    }
    if (![APPFunctionHelper checkEmailText:self])
    {
        *error = @"邮箱不正确";
        return NO;
    }
    return YES;
}
-(BOOL)CheckResumeCity:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"请选择城市";
        return NO;
    }
    return YES;
}
-(BOOL)CheckResumeGredute:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"请选择毕业时间";
        return NO;
    }
    return YES;
}
- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}
-(BOOL)CheckRealName:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"请输入真实姓名";
        return NO;
    }
    if (self.length > 16)
    {
        *error = @"真实姓名不能超过16个字符";
        return NO;
    }
    return YES;
}
-(BOOL)CheckUserName:(NSString**)error
{
    if (![self CheckResumeValid])
    {
        *error = @"请输入昵称";
        return NO;
    }
    if (self.length > 16)
    {
        *error = @"昵称不能超过16个字符";
        return NO;
    }
    return YES;
}
- (BOOL)CheckResumeWorkYear:(NSString *__autoreleasing *)error
{
    if (![self CheckResumeValid]) {
        *error = @"请选择工作年限";
        return NO;
    }
    return YES;
}
-(BOOL)CheckResumeRegin:(NSString**)error
{
    if (![self CheckResumeValid]) {
        *error = @"请选择居住地";
        return NO;
    }
    return YES;
}
@end