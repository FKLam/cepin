//
//  SubscriptionJobModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface SendSubscriptionJobModelDTO : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *UUID;//	String	UUID（机器唯一识别码）
@property(nonatomic,strong)NSString<Optional> *userId;//	String 	用户Id
@property(nonatomic,strong)NSString<Optional> *tokenId;//	string	用户授权
@property(nonatomic,strong)NSString<Optional> *address;//	String	工作地点（工作地点多选，最对三个，数据为Region的PathCode，多个时用“，”隔开）
@property(nonatomic,strong)NSString<Optional> *jobPropertys;//	String	工作性质（CodeKey）
@property(nonatomic,strong)NSString<Optional> *salary;//	String	薪酬（CodeKey）
@property(nonatomic,strong)NSString<Optional> *jobFunctions;//	String	职能（CodeKey，多个时用“，”隔开）
@property(nonatomic,strong)NSString<Optional> *industries;//	String	行业（CodeKey，多个时用“，”隔开）
@property(nonatomic,strong)NSString<Optional> *companyNature;//	String	公司性质（CodeKey）
@property(nonatomic,strong)NSString<Optional> *companySize;//	String	公司规模（CodeKey）

-(void)clearAll;
-(void)clearSearch;

@end

@interface SubscriptionJobModelDTO : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *address;//	String	工作地点（工作地点多选，最对三个，数据为Region的PathCode，多个时用“，”隔开）
@property(nonatomic,strong)NSString<Optional> *jobPropertys;//	String	工作性质（CodeKey）
@property(nonatomic,strong)NSString<Optional> *salary;//	String	薪酬（CodeKey）
@property(nonatomic,strong)NSString<Optional> *jobFunctions;//	String	职能（CodeKey，多个时用“，”隔开）
@property(nonatomic,strong)NSString<Optional> *industries;//	String	行业（CodeKey，多个时用“，”隔开）
@property(nonatomic,strong)NSString<Optional> *companyNature;//	String	公司性质（CodeKey）
@property(nonatomic,strong)NSString<Optional> *companySize;//	String	公司规模（CodeKey）
@property(nonatomic,strong)NSString<Optional> *workYear;//	String	公司规模（CodeKey）
@property(nonatomic,strong)NSString<Optional> *PositionType;//	String	招聘类型（CodeKey）
@end
