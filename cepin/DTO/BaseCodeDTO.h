//
//  BaseCodeDTO.h
//  cepin
//
//  Created by ricky.tang on 14+10+14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"

/**
 *  CodeKey	Int	唯一Key
 Level	Int	层级
 PathCode	String	code
 SortNumber	Int	排序
 CodeType	String	数据类型
 CodeName	String	数据名称
 */

@protocol BaseCode

@end

@interface BaseCode : JSONModel
@property(nonatomic,strong)NSNumber<Optional> *CodeKey;
@property(nonatomic,strong)NSNumber<Optional> *Level;
@property(nonatomic,strong)NSString<Optional> *PathCode;
@property(nonatomic,strong)NSNumber<Optional> *SortNumber;
@property(nonatomic,strong)NSString<Optional> *CodeType; //主健
@property(nonatomic,strong)NSString<Optional> *CodeName;



//查询工作年限
+(NSMutableArray *)workYears;

//查询学历
+(NSMutableArray *)degrees;

//查询公司规模
+(NSMutableArray *)companySize;

//查询公司性质
+(NSMutableArray *)companyNature;

//语言查询
+(NSMutableArray *)languages;

//查询技能等级 
+(NSMutableArray *)skillLevel;

//查询薪金（全职）
+(NSMutableArray *)salary;

//查询薪金(如果是兼职和实习)
+(NSMutableArray *)secondSalary;

//查询工作性质（全职、兼职、实习等）
+(NSMutableArray *)employType;

//查询工作职能一级列表
+(NSMutableArray *)jobFunction;

//查询工作职能二级菜单
+(NSMutableArray *)secondLevelJobFunctionWithPathCode:(NSString *)pathCode;

//查询工作职能三级菜单
+(NSMutableArray *)thirdLevelJobFunctionWithPathCode:(NSString *)pathCode;

//根据PathCode查询职能
+(NSMutableArray *)searchJobFunctionWithPathCode:(NSString *)pathcode;
//查询公司状态
+(NSMutableArray *)companyDevelopment;

//查询学生领导
+(NSMutableArray *)studentLeaders;

//查询薪金浮动值
+(NSMutableArray *)salaryFloatRate;

//查询奖励等级
+(NSMutableArray *)award;

//查询政治面貌
+(NSMutableArray *)politics;

//查询学校等级
+(NSMutableArray *)studyAchievement;

//查询计算机等级
+(NSMutableArray *)computerLevel;

//学科搜索
+(NSMutableArray *)majorWithName:(NSString *)name;

//学科搜索
+(NSMutableArray *)majorWithFullName:(NSString*)name;

+(BaseCode *)jobFunctionWithString:(NSString *)name;

//专业搜索
+(NSMutableArray *)DegreeWithFullName:(NSString *)name;

//所有专业
+(NSMutableArray *)AllMajor;


//查询学科一级列表
+(NSMutableArray *)major;


//查询学科二级列表
+(NSMutableArray *)secondLevelMajorWithPathCode:(NSString *)pathCode;


//查询学科三级列表
+(NSMutableArray *)thirdLevelMajorWithPathCode:(NSString *)pathCode;

//工作状态
+(NSMutableArray *)JobStatus;

//技能证书等级
+(NSMutableArray *)certificateNormal;

//专业证书
+(NSMutableArray *)Certificate;

//项目级别KeyanLevel
+(NSMutableArray *)KeyanLevel;

//参与项目等级
+(NSMutableArray *)keyanGroup;

//行业类型
+(NSMutableArray *)industry;

//行业类型二级列表
+(NSMutableArray *)SecondLevelIndustryWithPathCode:(NSString *)pathCode;

//证件类型
+(NSMutableArray *)IdCardType;

//查询证书
//+(NSMutableArray *)certificate;

//查询工作性质（全职、兼职、实习等）
+(BaseCode*)employTypeWithCode:(NSString*)code;

//查询薪水(由于薪水有两个plist，一个代表全职，一个代表兼职和实习的)
+(BaseCode*)salaryWithCodeAndEmployType:(NSString*)code type:(NSString*)type;

//根据codekey(多个codekey用逗号分隔)查询basecode数组
+(NSMutableArray*)baseCodeWithCodeKeys:(NSString*)str;

//根据pathcode查询basecode数组
+(NSMutableArray*)baseCodeWithPathCode:(NSString*)str;

+(BaseCode*)salaryWithName:(NSString*)str;

//根据codename(多个codename用逗号分隔)查询basecode数组
+ (NSMutableArray*)baseCodeWithCodeName:(NSString*)str;

//根据codekey(多个codekey用逗号分隔)查询basecode数组
+(NSMutableArray*)baseWithCodeKey:(NSString*)str;

//根据codekey(多个codetype用逗号分隔)查询basecode数组
+(NSMutableArray*)baseWithCodeType:(NSString*)str;
@end
