//
//  TBTextUnit.h
//  cepin
//
//  Created by Ricky Tang on 14-11-4.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegionDTO.h"
#import "BaseCodeDTO.h"
#import "SchoolDTO.h"

@interface TBTextUnit : NSObject

+(NSString *)allRegionCitiesWithRegions:(NSArray *)cities;

+(NSString *)allRegionPathCodeWithRegions:(NSArray *)cities;

+(NSString *)cityNamesWithCurrentRegion:(Region *)currentRegion regions:(NSArray *)cities;

+(NSString *)baseCodeNameWithPathCode:(NSArray *)pathcode;

+(NSString *)baseCodeNameWithBaseCodes:(NSArray *)baseCode;

+(NSString *)baseCodeKeyWithBaseCodesName:(NSArray *)baseName;

+(NSString *)baseCodeNameWithArray:(NSArray *)array;

+(NSString *)baseCodeNamesWithCurrentBaseCode:(BaseCode *)currentBaseCode baseCodes:(NSArray *)baseCodes;

+(NSString *)baseCodeNamesCountWithCurrentBaseCode:(BaseCode *)currentBaseCode baseCodes:(NSArray *)baseCodes;

+(NSString *)schoolNamesWithSchools:(NSArray *)schools;

+(NSString *)schoolIdsWithSchools:(NSArray *)schools;

+(NSString *)schoolNamesWithCurrentSchool:(School *)currentSchool schools:(NSArray *)schools;
+(NSString *)schoolNamesCountWithCurrentSchool:(School *)currentSchool schools:(NSArray *)schools;

+(NSString *)cityCountWithCurrentRegion:(Region *)currentRegion regions:(NSArray *)cities;

+(NSString*)allCodeKeyWithBaseCodeArray:(NSArray*)array;

+(NSString*)formatResumeDetail:(NSString*)degree school:(NSString*)school major:(NSString*)major;

+(NSArray*)formatCitysDetail:(NSArray*)cityList citys:(NSString*)citys;
+(NSString*)formatCitysDetailString:(NSArray*)cityList citys:(NSString*)citys;
+(NSString*)formatCitysDetailString2:(NSArray*)cityList citys:(NSString*)citys;

+(NSString*)fullResumeDetail:(NSString*)gender age:(NSString *)age workYear:(NSString*)workYear jobStatus:(NSString *)jobStatus;
+(NSString*)fullResumeDetail:(NSString*)city type:(NSString *)type function:(NSString*)function salary:(NSString *)salary;
+(NSString*)fullResumeDetail:(NSString*)major degle:(NSString *)degle;

+(NSString*)jobDetailWithAddress:(NSString*)address function:(NSString *)function educationLevel:(NSString *)educationLevel age:(NSString *)age experience:(NSString*)experience time:(NSString*)time PersonNumber:(NSString*)PersonNumber;

+ (NSString *)configWithJob:(NSString *)jobName address:(NSString*)address;
+ (NSString *)configWithCompany:(NSString *)company data:(NSString*)data;
+ (NSString *)configWithMouth:(NSString *)mouth day:(NSString*)day;

+(NSString*)formatSalary:(NSString*)salary company:(NSString*)company city:(NSString*)city;

+ (NSString*)searchJobWithPosition:(NSString*)position City:(NSString*)city salary:(NSString*)salary property:(NSString*)property workYear:(NSString*)workYear function:(NSString*)function positionType:(NSString*)positionType;

+ (NSString *)configWithTag:(NSArray*)tagArray;


+ (NSString *)configWithTime:(NSString *)time job:(NSString*)job;

+(NSString*)ResumeDetail:(NSString*)city nature:(NSString *)nature job:(NSString*)job salary:(NSString *)salary;

+(NSString*)formatAddress:(NSString*)address workyear:(NSString*)workyear age:(NSString*)age;



@end
