//
//  UserLoginDTO.h
//  cepin
//
//  Created by ricky.tang on 14-10-13.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"
/**
 *  UserId	String	用户ID
 UserName	String	昵称
 TokenId	String	登录唯一授权标识
 ExpiresIn	int	授权生命周期(24小时)
 LastActiveTime	String(Long)	最后活动时间
 PersonalitySignature
 PhotoUrl
 */
@interface UserLoginDTO : JSONModel
@property (nonatomic, strong) NSString<Optional> *AppDeviceToken;
@property (nonatomic, strong) NSString *Email;
@property (nonatomic, strong) NSNumber<Optional> *ExpiresIn;
@property (nonatomic, strong) NSString<Optional> *LastActiveTime;
@property (nonatomic, strong) NSString<Optional> *Moblie;
@property (nonatomic, strong) NSString<Optional> *PersonalitySignature;
@property (nonatomic, strong) NSString<Optional> *PhotoUrl;
@property (nonatomic, strong) NSNumber<Optional> *ResumeCount;
@property (nonatomic, strong) NSString<Optional> *TokenId;
@property (nonatomic, strong) NSString<Optional> *UserId;
@property (nonatomic, strong) NSString<Optional> *UserName;
@property (nonatomic, strong) NSString<Optional> *realName;
@property (nonatomic, strong) NSString<Optional> *IsVerifyEmail;
+(UserLoginDTO *)userLoginWithDictionary:(NSDictionary *)dic;
+(UserLoginDTO *)info;
+(instancetype)beanFromDictionary:(NSDictionary*)dic;
@end
