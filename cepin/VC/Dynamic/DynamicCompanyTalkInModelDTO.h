//
//  DynamicCompanyTalkInModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface DynamicCompanyTalkInModelDTO : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *CustomerId;//	String	企业id
@property(nonatomic,strong)NSString<Optional> *CompanyName;//	String	企业名称
@property(nonatomic,strong)NSString<Optional> *Logo;//	String	企业图片
@property(nonatomic,strong)NSString<Optional> *Content;// String	通知内容
@property(nonatomic,strong)NSString<Optional> *CreateDate;//消息时间

@end
