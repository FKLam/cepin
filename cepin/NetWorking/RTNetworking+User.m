//
//  RTNetworking+User.m
//  cepin
//
//  Created by ricky.tang on 14-10-13.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking+User.h"
#import "RTBase64.h"

@implementation RTNetworking (User)

//用户登录
-(RACSignal *)loginWithAccount:(NSString *)account password:(NSString *)password inviteCode:(NSString *)inviteCode
{
    return [[self.httpManager rac_POST:@"User/Login" parameters:@{@"account":account,@"password":password, @"inviteCode" : inviteCode,@"comeFrom":[NSString stringWithFormat:@"%ld",(long)100]}] logAll];
}
// 免密码登录接口
-(RACSignal *)exemptPasswordLoginWithMobile:(NSString *)mobile moblieCode:(NSString *)moblieCode inviteCode:(NSString *)inviteCode
{
    return [[self.httpManager rac_POST:@"/ThridEdition/user/ExemptPasswordLogin" parameters:@{@"account" : mobile, @"moblieCode" : moblieCode, @"inviteCode" : inviteCode ,@"comeFrom":[NSString stringWithFormat:@"%ld",(long)100]}] logAll];
}
//第三方登录
-(RACSignal *)thirdPartLoginWithUID:(NSString *)uid userName:(NSString *)userName type:(NSString *)type
{
    return [self.httpManager rac_POST:@"User/ThirdPartLogin" parameters:@{@"uid":uid,@"userName":userName,@"type":type,@"comeFrom":[NSString stringWithFormat:@"%ld",(long)100]}];
}
//用户注册
-(RACSignal *)registerWithEmail:(NSString *)email mobile:(NSString *)mobile userName:(NSString *)userName password:(NSString *)password comeFrom:(NSInteger)comeFrom
{
    return [[self.httpManager rac_POST:@"User/Register" parameters:@{@"email":email,@"mobile":mobile,@"userName":userName,@"password":password,@"comeFrom":[NSString stringWithFormat:@"%ld",(long)comeFrom]}] logAll];
}
//获取个人信息
-(RACSignal *)userInfomationWithTokenId:(NSString *)tokenId userId:(NSString *)userId
{
    return [self.httpManager rac_GET:@"User/Get" parameters:@{@"tokenid":tokenId,@"userId":userId}];
}
//修改个人信息
-(RACSignal *)editUserInfoWithEmail:(NSString *)email mobile:(NSString *)mobile userName:(NSString *)userName personalitySignature:(NSString *)personalitySignature
{
    return [self.httpManager rac_POST:@"User/Edit" parameters:@{@"email":email,@"mobile":mobile,@"userName":userName,@"personalitySignature":personalitySignature,@"tokenId":[[MemoryCacheData shareInstance]userTokenId],@"userId":[[MemoryCacheData shareInstance]userId]}];
}
// 用户反馈
-(RACSignal *)feedbackWithMobileOrEmail:(NSString *)mobileOrEmail  contentText:(NSString *)contentText version:(NSString *)version
{
    return [self.httpManager rac_POST:@"User/Feedback" parameters:@{@"mobileOrEmail":mobileOrEmail,@"contentText":contentText, @"version" : version, @"SourceType" : @"4"}];
}
// 忘记密码
-(RACSignal *)forgetPasswordWithEmail:(NSString *)email
{
    return [self.httpManager rac_GET:@"User/ForgotPassword" parameters:@{@"email": email}];
}
-(RACSignal *)getOtherUserInfo:(NSString *)tokenId userId:(NSString *)userId otherUserId:(NSString *)friendsUserId
{
    return [self.httpManager rac_GET:@"User/GetFriend" parameters:@{@"tokenid":tokenId,@"userId":userId,@"friendUserId":friendsUserId}];
}
//获取找回密码手机验证码
-(RACSignal *)getMobileValidateSmsAccount:(NSString *)account ForgotType:(NSString*)ForgotType
{
    return [self.httpManager rac_POST:@"/User/SendForgotPasswordMsg" parameters:@{@"Account":account,@"ForgotType":ForgotType}];
}
//获取手机验证码
-(RACSignal *)getMobileValidateSmsAccount:(NSString *)account
{
     return [self.httpManager rac_POST:@"/User/SendMobileValidateSms" parameters:@{@"Account":account}];
}
// 这个是专门发送手机号码的验证，不能用于其他注册之类的验证
- (RACSignal *)sendMobileValidateSmsForVerifyWithAccount:(NSString *)account
{
    return [self.httpManager rac_POST:@"/User/SendMobileValidateSmsForVerify" parameters:@{ @"account" : account}];
}
//发送免密码登录的手机验证码接口
- (RACSignal *)sendExemptPasswordLoginMoblieValidateSmsWithMoblie:(NSString *)moblie
{
    return [self.httpManager rac_POST:@"/ThridEdition/user/SendExemptPasswordLoginMoblieValidateSms" parameters:@{ @"moblie" : moblie}];
}
//获取注册手机验证码
-(RACSignal *)getMobileValidateSmsAccount:(NSString *)account type:(NSString *)type
{
     return [self.httpManager rac_POST:@"/User/SendMobileValidateSms" parameters:@{@"Account":account,@"type":type}];
}
- (RACSignal *)registerWithAccount:(NSString *)account passWord:(NSString *)password Validatecode:(NSString *)validatecode comeFrom:(NSInteger)comeFrom inviteCode:(NSString *)inviteCode
{
    return [[self.httpManager rac_POST:@"User/Register_ForThird" parameters:@{@"Account":account,@"Password":password,@"Validatecode":validatecode,@"comeFrom":[NSString stringWithFormat:@"%ld",(long)comeFrom], @"inviteCode" : inviteCode}] logAll];
}
- (RACSignal *)bindThirdLoginWithAccount:(NSString *)account passWord:(NSString *)password serId:(NSString*)userId tokenId:(NSString*)tokenId bindType:(NSString *)bindType moblieValidateCode:(NSString *)moblieValidateCode
{
    return [self.httpManager rac_POST:@"/ThridEdition/User/BindThirdLogin" parameters:@{ @"Account" : account, @"Password" : password, @"userId" : userId, @"tokenId" : tokenId, @"bindType" : bindType, @"moblieValidateCode" : moblieValidateCode }];
}
- (RACSignal *)emailAccountBindMobile:(NSString *)mobile serId:(NSString*)userId tokenId:(NSString*)tokenId bindType:(NSString *)bindType moblieValidateCode:(NSString *)moblieValidateCode password:(NSString *)password
{
    return [self.httpManager rac_POST:@"/ThridEdition/User/BindThirdLogin" parameters:@{ @"account" : mobile, @"userId" : userId, @"tokenId" : tokenId, @"bindType" : bindType, @"moblieValidateCode" : moblieValidateCode , @"password" : password}];
}
- (RACSignal *)bindExistAccountWithAccount:(NSString *)account passWord:(NSString *)password serId:(NSString*)userId tokenId:(NSString*)tokenId bindType:(NSString *)bindType
{
    return [self.httpManager rac_POST:@"/ThridEdition/User/BindThirdLogin" parameters:@{ @"Account" : account, @"Password" : password, @"userId" : userId, @"tokenId" : tokenId, @"bindType" : bindType}];
}
-(RACSignal *)forgetPasswordWithAccount:(NSString *)account ForgotType:(NSInteger)forgotType
{
    return [self.httpManager rac_POST:@"/User/SendForgotPasswordMsg" parameters:@{@"Account": account,@"ForgotType":[NSString stringWithFormat:@"%ld",(long)forgotType]}];
}
-(RACSignal *)forgetPasswordWithAccount:(NSString *)account password:(NSString *)password validateCode:(NSString *)validateCode
{
    return [self.httpManager rac_POST:@"User/ForgotPassword_ForThird" parameters:@{@"Account":account,@"Password":password,@"validateCode":validateCode}];
}
-(RACSignal *)editUserInfoWithUserId:(NSString *)userId tokenId:(NSString *)tokenId Realname:(NSString *)Realname UserName:(NSString *)UserName
{
    return [self.httpManager rac_POST:@"User/Edit_ForThird" parameters:@{@"Userid":userId,@"TokenId":tokenId,@"Realname":Realname,@"UserName":UserName}];
}
//获取个人信息3.0
-(RACSignal *)userInfomationWithTokenId:(NSString *)tokenId userId:(NSString *)userId Realname:(NSString *)realname UserName:(NSString *)userName
{
    return [self.httpManager rac_POST:@"User/Edit_ForThird" parameters:@{@"tokenid":tokenId,@"userId":userId,@"Realname":realname,@"UserName":userName}];
}
-(RACSignal *)userInfomationWithTokenId:(NSString *)tokenId userId:(NSString *)userId Mobile:(NSString *)mobile ValidateCode:(NSString *)validateCode
{
     return [self.httpManager rac_POST:@"User/EditMobile" parameters:@{@"tokenid":tokenId,@"userId":userId,@"Mobile":mobile,@"ValidateCode":validateCode}];
}
-(RACSignal *)getEmailUserInfo:(NSString *)tokenId userId:(NSString *)userId Email:(NSString *)email
{
    return [self.httpManager rac_POST:@"/User/EditEmail" parameters:@{@"tokenid":tokenId,@"userId":userId,@"Email":email}];
}
//修改密码
- (RACSignal *)changeUserPassWordWithUserId:(NSString*)userId tokenId:(NSString*)tokenId password:(NSString*)password oldPassword:(NSString*)oldPassword
{
    return [self.httpManager rac_POST:@"/ThridEdition/User/UpdatePassword" parameters:@{@"tokenid":tokenId,@"userId":userId,@"password":password,@"oldPassword":oldPassword}];
}
//新增3.1
//检测是做过测评
- (RACSignal *)checkIsCepingWithUserId:(NSString*)userId tokenId:(NSString*)tokenId
{
    return [self.httpManager rac_POST:@"/ThridEdition/User/IsOpenSpeedExam" parameters:@{@"tokenid":tokenId,@"userId":userId}];
}
//上传用户token信息
- (RACSignal *)updateAppTokenWithUserId:(NSString *)UserId tokenId:(NSString *)TokenId appDeviceToken:(NSString *)appDeviceToken{
    return [self.httpManager rac_POST:@"/ThridEdition/User/UpdateAppDeviceToken" parameters:@{@"TokenId":TokenId,@"UserId":UserId,@"appDeviceToken":appDeviceToken}];
}
-(RACSignal *)updateAppVersion:(NSString *)appVersion UserId:(NSString *)UserId{
    return [self.httpManager rac_POST:@"/ThridEdition/User/UpdateAppVersion"
                           parameters:@{@"appType":@"2",@"appVersion":appVersion,@"UserId":UserId}];
}
// 企业邀请测评
- (RACSignal *)getPersonExamListWithUserID:(NSString *)UserID tokenID:(NSString *)tokenID
{
    return [self.httpManager rac_GET:@"/ThridEdition/User/GetPersonExamList" parameters:@{@"tokenid":tokenID,@"userId":UserID}];
}
@end
