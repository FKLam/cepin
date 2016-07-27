//
//  DynamicFairModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface DynamicFairModelDTO : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *FairName;//	String	宣讲会名称
@property(nonatomic,strong)NSString<Optional> *FairId;//	String	宣讲会Id
@property(nonatomic,strong)NSString<Optional> *BeginTime;//	String	开始时间
@property(nonatomic,strong)NSString<Optional> *CreateDate;//	String	发布时间
@property(nonatomic,strong)NSString<Optional> *Address;//	string	地点

@end
