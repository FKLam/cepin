//
//  JobDetailModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "MJExtension.h"

@protocol ApplyUserModel
@end

@interface ApplyUserModel : JSONModel

@property(nonatomic,strong)NSString<Optional> *UserId;
@property(nonatomic,strong)NSString<Optional> *UserName;
@property(nonatomic,strong)NSString<Optional> *UserPicture;

+(ApplyUserModel*)beanFromDictionary:(NSDictionary*)dic;

@end



@interface JobDetailModelDTO : JSONModel

@property(nonatomic,strong)NSString<Optional> *PositionName;
@property(nonatomic,strong)NSString<Optional> *PositionId;
@property(nonatomic,strong)NSString<Optional> *PositionNature;
@property(nonatomic,strong)NSString<Optional> *City;
@property(nonatomic,strong)NSString<Optional> *Salary;
@property(nonatomic,strong)NSString<Optional> *CompanyName;
@property(nonatomic,strong)NSString<Optional> *CustomerId;
@property(nonatomic,strong)NSArray<Optional> *Tags;
@property(nonatomic,strong)NSString<Optional> *EducationLevel;
@property(nonatomic,strong)NSString<Optional> *Major;
@property(nonatomic,strong)NSString<Optional> *PersonNumber;
@property(nonatomic,strong)NSString<Optional> *Age;
@property(nonatomic,strong)NSString<Optional> *Department;
@property(nonatomic,strong)NSString<Optional> *JobDescription;
@property(nonatomic,strong)NSString<Optional> *HtmlJobDescription;
@property(nonatomic,strong)NSString<Optional> *PublishDate;
@property(nonatomic,strong)NSArray<ApplyUserModel> *ApplyUsers;
@property(nonatomic,strong)NSNumber<Optional> *IsDeliveried;
@property(nonatomic,strong)NSNumber<Optional> *IsCollection;
@property(nonatomic,strong)NSString<Optional> *WorkYear;
@property (nonatomic, strong) NSString *Introduction;

@property (nonatomic, strong) NSString *CompanyCity;
@property (nonatomic, strong) NSString *CompanyLogoUrl;
@property (nonatomic, strong) NSString *CompanySize;
@property (nonatomic, strong) NSString *JobFunction;

//+(JobDetailModelDTO*)beanFromDictionary:(NSDictionary*)dic;
+(instancetype)beanFromDictionary:(NSDictionary*)dic;
@end
