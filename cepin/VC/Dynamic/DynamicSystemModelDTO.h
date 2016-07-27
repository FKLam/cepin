//
//  DynamicSystemModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface DynamicSystemModelDTO : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *Title;//	String	消息名称
@property(nonatomic,strong)NSString<Optional> *MessageId;	//String	消息Id
@property(nonatomic,strong)NSString<Optional> *CreateDate;	//string	发布时间
@property(nonatomic,strong)NSString<Optional> *Content;//	String	内容
@property(nonatomic,strong)NSString<Optional> *HtmlContent;//	String	内容
@end
