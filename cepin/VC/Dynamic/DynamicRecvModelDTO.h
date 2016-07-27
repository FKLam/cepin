//
//  DynamicRecvModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface DynamicRecvModelDTO : BaseBeanModel

@property(nonatomic,strong)NSNumber<Optional> *Count;//	Int	信息的数量
@property(nonatomic,strong)NSString<Optional> *Message;//	String	信息最新一条描述
@property(nonatomic,strong)NSString<Optional> *CreateDate;//	String	信息产生的时间
@property(nonatomic,strong)NSNumber<Optional> *Type;//	Int	数据类型（0:工作动态；1：宣讲会；2:系统消息；3:测评中心）

@end
