//
//  JobSearchModel.h
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface JobSearchModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *PositionName;
@property(nonatomic,strong)NSString<Optional> *PositionId;
@property(nonatomic,strong)NSString<Optional> *PositionNature;
@property(nonatomic,strong)NSString<Optional> *City;
@property(nonatomic,strong)NSString<Optional> *Salary;
/** 公司全称 */
@property(nonatomic,strong)NSString<Optional> *CompanyName;
@property(nonatomic,strong)NSString<Optional> *CustomerId;
@property(nonatomic,strong)NSString<Optional> *Logo;
@property(nonatomic,strong)NSString<Optional> *CollectDate;
@property(nonatomic,strong)NSString<Optional> *PublishDate;
@property(nonatomic,strong)NSNumber<Optional> *IsDeliveried;
@property(nonatomic,strong)NSNumber<Optional> *IsCollection;
@property(nonatomic,strong)NSNumber<Optional> *IsTop;
//3.1新增
@property(nonatomic,strong)NSString<Optional> *WorkYear;            //要求工作年限
@property(nonatomic,strong)NSString<Optional> *EducationLevel;      //要求教育程度
@property(nonatomic,strong)NSString<Optional> *Welfare;             //职位诱惑
@property(nonatomic,strong)NSNumber<Optional> *PositionType;        //简历类型
/** 公司简称 */
@property (nonatomic, strong) NSString<Optional> *Shortname;

@property (nonatomic, strong) NSString<Optional> *CompanyCity;
@property (nonatomic, strong) NSString<Optional> *CompanyLogo;
@property (nonatomic, strong) NSString<Optional> *CompanyNature;
@property (nonatomic, strong) NSString<Optional> *CompanySize;
@property (nonatomic, strong) NSString<Optional> *IndustryName;
@property (nonatomic, strong) NSString<Optional> *Address;
@property (nonatomic, strong) NSString<Optional> *CompanyIndustry;
@property(nonatomic,strong)NSArray<Optional> *Tags;
@property (nonatomic, strong) NSString<Optional> *Introduction;
@property (nonatomic, strong) NSString<Optional> *CompanyLogoUrl;



@property (nonatomic, strong) NSString<Optional> *ViewedDate;
@end


