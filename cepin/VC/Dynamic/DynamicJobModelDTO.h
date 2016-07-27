//
//  DynamicJobModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-9.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@protocol DynamicJobList
@end


@interface DynamicJobList : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *PositionName;//	String	职位名称
@property(nonatomic,strong)NSString<Optional> *PositionId;//	String	职位Id
@property(nonatomic,strong)NSString<Optional> *EmployType;//	String	职位性质（全职，兼职，实习）
@property(nonatomic,strong)NSString<Optional> *City;//	String	工作地点
@property(nonatomic,strong)NSString<Optional> *Salary;//	string	薪酬


@end

@interface DynamicJobModelDTO : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *CompanyName;//	String	公司名称
@property(nonatomic,strong)NSString<Optional> *CustomerId;//	String	公司Id
@property(nonatomic,strong)NSString<Optional> *Logo;//	String	公司图片
@property(nonatomic,strong)NSString<Optional> *CreateDate;//	string	发布时间
@property(nonatomic,strong)NSArray<DynamicJobList> *PositionList;//	List<T>	公司职位

@end
