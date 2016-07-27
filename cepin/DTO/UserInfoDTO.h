//
//  UserInfoDTO.h
//  cepin
//
//  Created by tassel.li on 14-10-9.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"


/**
 *  Email	String	用户邮箱
 UserName	String	昵称
 Gender	Int	性别（1：男，2：女）
 RealName	String	真实姓名
 BirthDate	Datetime	出生年月
 Mobile	String	电话
 School	String	学校
 SchoolId	String	学校key
 Major	String	专业
 MajorKey	String	专业Key
 */

@interface UserInfoDTO : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *Account;
@property(nonatomic,strong)NSNumber<Optional> *IsHasEmailVerify;
@property(nonatomic,strong)NSString<Optional> *Email;
@property(nonatomic,strong)NSString<Optional> *UserName;
@property(nonatomic,strong)NSNumber<Optional> *Gender;
@property(nonatomic,strong)NSString<Optional> *RealName;
@property(nonatomic,strong)NSString<Optional> *BirthDate;
@property(nonatomic,strong)NSString<Optional> *Mobile;
@property(nonatomic,strong)NSString<Optional> *School;
@property(nonatomic,strong)NSString<Optional> *SchoolId;
@property(nonatomic,strong)NSString<Optional> *Major;
@property(nonatomic,strong)NSString<Optional> *MajorKey;
@property(nonatomic,strong)NSString<Optional> *PhotoUrl;
@property(nonatomic,strong)NSString<Optional> *PersonalitySignature;

+(UserInfoDTO *)userInfoWithDictionary:(NSDictionary *)dic folder:(NSString*)folder;
+(UserInfoDTO *)info:(NSString*)folder;
+(UserInfoDTO *)OtherUserInfo:(NSDictionary *)dic;

-(void)checkValid;

@end
