//
//  SubscriptionJobModel.h
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface SubscriptionJobModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *address;//	String	工作地点
@property(nonatomic,strong)NSString<Optional> *jobPropertys;//	String	类型
@property(nonatomic,strong)NSString<Optional> *salary;//	String	薪酬
@property(nonatomic,strong)NSString<Optional> *jobFunctions;//	String	职能
@property(nonatomic,strong)NSString<Optional> *workYear;//	String	工作年限
@property(nonatomic,strong)NSString<Optional> *addresskey;//	String	工作地点key
@property(nonatomic,strong)NSString<Optional> *jobPropertyskey;//	String	类型key
@property(nonatomic,strong)NSString<Optional> *salarykey;//	String	薪酬key
@property(nonatomic,strong)NSString<Optional> *jobFunctionskey;//	String	职能key
@property(nonatomic,strong)NSString<Optional> *workYearkey;//	String	工作年限key
@property(nonatomic,strong)NSString<Optional> *positionType;//	String	招聘类型key
@property(nonatomic,strong)NSString<Optional> *positionTypekey;//	String	招聘类型key(""不限 1校招 2社招)
@property(nonatomic,strong)NSString<Optional> *workYearMin;//	String	工作年限最小值
@property(nonatomic,strong)NSString<Optional> *workYearMax;//	String	工作年限最大值
@property(nonatomic,strong)NSString<Optional> *Degree;//学历码表
@property(nonatomic,strong)NSString<Optional> *DegreeStr;//学历

- (void)config;
@end
