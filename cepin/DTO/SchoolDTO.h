//
//  SchoolDTO.h
//  cepin
//
//  Created by ricky.tang on 14-10-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"

/**
 *  Name	String	学校名称
 SchoolType	String	学校分组 （理工 农科）
 SchoolClass	Int	学校类型 （1：985,2：211）
 RegionCode	String	地区code
 Province	String	省份
 City	String	城市
 SchoolId	Guid	学校编号
 */

@protocol School 

@end

@interface School : JSONModel
@property(nonatomic,strong)NSString<Optional> *Name;
@property(nonatomic,strong)NSString<Optional> *EnName;
@property(nonatomic,strong)NSString<Optional> *SchoolType;
@property(nonatomic,strong)NSNumber<Optional> *SchoolClass;
@property(nonatomic,strong)NSString<Optional> *RegionCode;
@property(nonatomic,strong)NSString<Optional> *Province;
@property(nonatomic,strong)NSString<Optional> *City;
@property(nonatomic,strong)NSString<Optional> *SchoolId;
@property(nonatomic,strong)NSString<Optional> *Country;



+(NSMutableArray *)school;
+(NSMutableArray *)schoolWithName:(NSString *)name;
+(NSMutableArray *)schoolWithFullName:(NSString *)name;
+(NSMutableArray *)schoolAddress;
+(NSMutableArray *)schoolsWithProvince:(NSString *)province;
+(NSMutableArray *)shoolsWithShoolNames:(NSString*)shoolNames province:(NSString*)province;
//根据shools查询shool
+(NSMutableArray*)searchSchoolsWithShoolIds:(NSString*)schools;

//根据schools查询
+(NSMutableArray*)searchSchoolsWithShoolNames:(NSString*)schools;

@end
