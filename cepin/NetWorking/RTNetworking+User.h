//
//  RTNetworking+User.h
//  cepin
//
//  Created by ricky.tang on 14-10-13.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking.h"

@interface RTNetworking (User)

/*
 3.1  用户接口

   接口说明
 3.1.1  用户登录。
 URL
 http://App2.cepin.com/User/Login
 HTTP请求方式
 POST
 请求Headers
 无
 请求参数

 return UserLoginDTO
 */

-(RACSignal *)loginWithAccount:(NSString *)account password:(NSString *)password inviteCode:(NSString *)inviteCode;

/**
 *  接口说明
 3.1.2  第三方登录。
 URL
 http://App2.cepin.com/User/ThirdPartLogin
 HTTP请求方式
 POST
 请求Headers
 
 return UserLoginDTO
 */

-(RACSignal *)thirdPartLoginWithUID:(NSString *)uid userName:(NSString *)userName type:(NSString *)type;

/**
 *  接口说明
 3.1.3  用户注册
 URL
 http://app2.cepin.com/User/Register
 //  http://app.cepin.com/AppUser/Register
 HTTP请求方式
 POST
 请求Headers
 
 return UserLoginDTO
 */
-(RACSignal *)registerWithEmail:(NSString *)email mobile:(NSString *)mobile userName:(NSString *)userName password:(NSString *)password comeFrom:(NSInteger)comeFrom;


/**
 *  接口说明
 3.1.5  获取个人信息
 URL
 http://app2.cepin.com/User/Get
 //  http://app.cepin.com/AppUser/Get
 HTTP请求方式
 get
 请求Headers
 
 return UserInfoDTO
 */

-(RACSignal *)userInfomationWithTokenId:(NSString *)tokenId userId:(NSString *)userId;


/**
 *  接口说明
 3.1.6  修改个人信息
 URL
 http://app2.cepin.com/User/Edit
 // http://app.cepin.com/AppUser/Edit
 HTTP请求方式
 post
 请求Headers
 */

-(RACSignal *)editUserInfoWithEmail:(NSString *)email mobile:(NSString *)mobile userName:(NSString *)userName personalitySignature:(NSString *)personalitySignature;


/**
 *  接口说明
 3.1。9  用户反馈
 URL
 http://app2.cepin.com/User/Feedback
//   http://app.cepin.com/ AppUser/Feedback
 HTTP请求方式
 post
 请求Headers
 */

-(RACSignal *)feedbackWithMobileOrEmail:(NSString *)mobileOrEmail  contentText:(NSString *)contentText version:(NSString *)version;


/**
 *  接口说明
 3.1.7  忘记密码
 URL
 http://app2.cepin.com/User/ForgotPassword
//   http://app.cepin.com/AppUser/ForgotPassword
 HTTP请求方式
 get
 请求Headers
 */

-(RACSignal *)forgetPasswordWithEmail:(NSString *)email;


/**
 *  接口说明
 个人中心首页
 URL
 http://app.cepin.com/AppUser/UserCenter
 HTTP请求方式
 GET
 请求Headers
 */

//-(RACSignal *)userCenterWithTokenId:(NSString *)tokenId userId:(NSString *)userId;


/**
 *  接口说明
 3.1.8  用户头像修改接口
 URL
 http://app2.cepin.com/User/UploadUserImg
  //  http://app.cepin.com/AppUser/UploadUserImg
 HTTP请求方式
 GET
 请求Headers
 */

//-(RACSignal *)uploadUserImageWithtokenId:(NSString *)tokenId userId:(NSString *)userId image:(UIImage *)image;

-(RACSignal *)getOtherUserInfo:(NSString *)tokenId userId:(NSString *)userId otherUserId:(NSString *)friendsUserId;

//获取找回密码手机验证码
-(RACSignal *)getMobileValidateSmsAccount:(NSString *)account ForgotType:(NSString*)ForgotType;

//获取手机验证码
-(RACSignal *)getMobileValidateSmsAccount:(NSString *)account;
//获取验证码
-(RACSignal *)getMobileValidateSmsAccount:(NSString *)account type:(NSString*)type;

//注册
-(RACSignal *)registerWithAccount:(NSString *)account passWord:(NSString *)password Validatecode:(NSString *)validatecode comeFrom:(NSInteger)comeFrom inviteCode:(NSString *)inviteCode;

//忘记密码找回密码
-(RACSignal *)forgetPasswordWithAccount:(NSString *)account ForgotType:(NSInteger)forgotType;
//忘记密码保存
-(RACSignal *)forgetPasswordWithAccount:(NSString *)account password:(NSString *)password validateCode:(NSString *)validateCode;

-(RACSignal *)editUserInfoWithUserId:(NSString *)userId tokenId:(NSString *)tokenId Realname:(NSString *)Realname UserName:(NSString *)UserName;


//获取个人信息3.0
-(RACSignal *)userInfomationWithTokenId:(NSString *)tokenId userId:(NSString *)userId Realname:(NSString *)realname UserName:(NSString *)userName;

//修改手机号码3.0
-(RACSignal *)userInfomationWithTokenId:(NSString *)tokenId userId:(NSString *)userId Mobile:(NSString *)mobile ValidateCode:(NSString *)validateCode;

-(RACSignal *)getEmailUserInfo:(NSString *)tokenId userId:(NSString *)userId Email:(NSString *)email;

//修改密码
- (RACSignal *)changeUserPassWordWithUserId:(NSString*)userId tokenId:(NSString*)tokenId password:(NSString*)password oldPassword:(NSString*)oldPassword;
//检测用户是都测评
- (RACSignal *)checkIsCepingWithUserId:(NSString*)userId tokenId:(NSString*)tokenId;
//3.1提交token信息
-(RACSignal *)updateAppTokenWithUserId:(NSString*)UserId tokenId:(NSString*)TokenId appDeviceToken:(NSString*)appDeviceToken;
-(RACSignal *)updateAppVersion:(NSString*)appVersion UserId:(NSString*)UserId;//提交app版本
// 企业邀请测评
- (RACSignal *)getPersonExamListWithUserID:(NSString *)UserID tokenID:(NSString *)tokenID;
// 第三方绑定新帐号
- (RACSignal *)bindThirdLoginWithAccount:(NSString *)account passWord:(NSString *)password serId:(NSString*)userId tokenId:(NSString*)tokenId bindType:(NSString *)bindType moblieValidateCode:(NSString *)moblieValidateCode;
// 这个是专门发送手机号码的验证，不能用于其他注册之类的验证
- (RACSignal *)sendMobileValidateSmsForVerifyWithAccount:(NSString *)account;
// 绑定已有帐号
- (RACSignal *)bindExistAccountWithAccount:(NSString *)account passWord:(NSString *)password serId:(NSString*)userId tokenId:(NSString*)tokenId bindType:(NSString *)bindType;
//发送免密码登录的手机验证码接口
- (RACSignal *)sendExemptPasswordLoginMoblieValidateSmsWithMoblie:(NSString *)moblie;
// 免密码登录接口
-(RACSignal *)exemptPasswordLoginWithMobile:(NSString *)mobile moblieCode:(NSString *)moblieCode inviteCode:(NSString *)inviteCode;
// 邮箱登录绑定手机号码
- (RACSignal *)emailAccountBindMobile:(NSString *)mobile serId:(NSString*)userId tokenId:(NSString*)tokenId bindType:(NSString *)bindType moblieValidateCode:(NSString *)moblieValidateCode password:(NSString *)password;
@end
