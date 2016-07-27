//
//  CompanyDetailModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "JobSearchVM.h"

@protocol CompanyPositionModel
@end

@interface CompanyPositionModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *PositionName;
@property(nonatomic,strong)NSString<Optional> *PositionId;
@property(nonatomic,strong)NSString<Optional> *PositionNature;
@property(nonatomic,strong)NSString<Optional> *Address;
@property(nonatomic,strong)NSString<Optional> *Salary;
@property(nonatomic,strong)NSNumber<Optional> *IsCollection;
@property(nonatomic,strong)NSNumber<Optional> *IsDeliveried;
@property(nonatomic,strong)NSString<Optional> *CompanyName;
@property(nonatomic,strong)NSString<Optional> *PublishDate;
@property(nonatomic,strong)NSNumber<Optional> *IsTop;
@property(nonatomic,strong)NSString<Optional> *City;

//3.1新增
@property(nonatomic,strong)NSString<Optional> *WorkYear;//要求工作年限
@property(nonatomic,strong)NSString<Optional> *EducationLevel;//要求工作年限
@property(nonatomic,strong)NSString<Optional> *Welfare;//职位诱惑
@property(nonatomic,strong)NSNumber<Optional> *PositionType;//简历类型
@end

@protocol CompanyFairModel
@end

@interface CompanyFairModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *FairName;
@property(nonatomic,strong)NSString<Optional> *FairId;
@property(nonatomic,strong)NSString<Optional> *BeginTime;
@property(nonatomic,strong)NSString<Optional> *PublishDate;
@property(nonatomic,strong)NSString<Optional> *Address;
@property(nonatomic,strong)NSString<Optional> *IsCollection;
@end

@protocol CompanyEnvironmentModel
@end

@interface CompanyEnvironmentModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *PicId;
@property(nonatomic,strong)NSString<Optional> *PicPath;
@property(nonatomic,strong)NSString<Optional> *PicDescription;
@end

@interface CompanyDetailModelDTO : JSONModel

@property(nonatomic,strong)NSString<Optional> *CustomerId;
@property(nonatomic,strong)NSString<Optional> *CompanyName;
@property(nonatomic,strong)NSString<Optional> *Logo;
@property(nonatomic,strong)NSString<Optional> *Introduction;
@property(nonatomic,strong)NSString<Optional> *Address;
@property(nonatomic,strong)NSString<Optional> *CompanySize;
@property(nonatomic,strong)NSString<Optional> *CompanyNature;
@property(nonatomic,strong)NSString<Optional> *IsListedCompany;
@property(nonatomic,strong)NSString<Optional> *Industry;
@property(nonatomic,strong)NSString<Optional> *Description;
@property(nonatomic,strong)NSNumber<Optional> *IsCollection;
@property(nonatomic,strong)NSMutableArray<JobSearchVM> *AppPositionInfoList;
@property(nonatomic,strong)NSMutableArray<CompanyFairModel> *AppCampusFairList;
@property(nonatomic,strong)NSMutableArray<CompanyEnvironmentModel> *AppEnvironmentList;
@property(nonatomic,strong)NSString<Optional> *SpecialRecruitmentUrl;


+(CompanyDetailModelDTO*)beanFromDictionary:(NSDictionary*)dic;

@end
