//
//  TBTextUnit.m
//  cepin
//
//  Created by Ricky Tang on 14-11-4.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "TBTextUnit.h"
#import "NSString+Convert.h"

@implementation TBTextUnit

+(NSString *)cityCountWithCurrentRegion:(Region *)currentRegion regions:(NSArray *)cities
{
    int count = 0;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    
    for (Region *i in cities) {
        if ([i.PathCode rangeOfString:currentRegion.PathCode].length > 0) {
            if (i.Hot.intValue == 0)
            {
                [temp addObject:i.RegionName];
                count++;
            }
        }
    }
    if (count > 0)
    {
        return [NSString stringWithFormat:@"已选%d个",count];
    }
    return @"";
}

+(NSString *)allRegionCitiesWithRegions:(NSArray *)cities
{
    NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (Region *i in cities) {
        [temp addObject:i.RegionName];
    }
    string = [temp componentsJoinedByString:@", "];
    
    return string;
}

+(NSString *)allRegionPathCodeWithRegions:(NSArray *)cities
{
    BOOL hasPathCode = NO;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (Region *i in cities) {
        [temp addObject:i.PathCode];
        hasPathCode = YES;
    }
    if (hasPathCode)
    {
        return [temp componentsJoinedByString:@","];
    }
    return @"";
}

+(NSString *)cityNamesWithCurrentRegion:(Region *)currentRegion regions:(NSArray *)cities
{
    NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    
    for (Region *i in cities) {
        if ([i.PathCode rangeOfString:currentRegion.PathCode].length > 0) {
            [temp addObject:i.RegionName];
        }
    }
    
    string = [temp componentsJoinedByString:@","];
    return string;
}

+(NSString *)baseCodeNameWithPathCode:(NSArray *)pathcode
{
    NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (BaseCode *i in pathcode) {
        [temp addObject:i.PathCode];
    }
    string = [temp componentsJoinedByString:@","];
    return string;
}

+(NSString *)baseCodeNameWithBaseCodes:(NSArray *)baseCode
{
    NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (BaseCode *i in baseCode) {
        [temp addObject:i.CodeName];
    }
    string = [temp componentsJoinedByString:@", "];
    return string;
}

+(NSString *)baseCodeKeyWithBaseCodesName:(NSArray *)baseName
{
    NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (BaseCode *i in baseName) {
        [temp addObject:i.CodeKey];
    }
    string = [temp componentsJoinedByString:@","];
    return string;
}

+(NSString *)baseCodeNameWithArray:(NSArray *)array
{
    NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (NSString *i in array) {
        [temp addObject:i];
    }
    string = [temp componentsJoinedByString:@","];
    return string;
}


+(NSString *)baseCodeNamesCountWithCurrentBaseCode:(BaseCode *)currentBaseCode baseCodes:(NSArray *)baseCodes
{
    int count = 0;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    
    for (BaseCode *item in baseCodes) {
        if ([item.PathCode rangeOfString:currentBaseCode.PathCode].length > 0) {
            [temp addObject:item.CodeName];
            count++;
        }
    }
    if (count > 0)
    {
        return [NSString stringWithFormat:@"已选%d个",count];
    }
    return @"";
}

+(NSString *)baseCodeNamesWithCurrentBaseCode:(BaseCode *)currentBaseCode baseCodes:(NSArray *)baseCodes
{
    NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    
    for (BaseCode *item in baseCodes) {
        if ([item.PathCode rangeOfString:currentBaseCode.PathCode].length > 0) {
            [temp addObject:item.CodeName];
        }
    }
    string = [temp componentsJoinedByString:@","];
    return string;
}


+(NSString *)schoolNamesWithSchools:(NSArray *)schools
{
    NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (School *i in schools) {
        [temp addObject:i.Name];
    }
    string = [temp componentsJoinedByString:@","];
    return string;
}

+(NSString *)schoolIdsWithSchools:(NSArray *)schools
{
    BOOL isHasSchoolId = NO;
    //NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (School *i in schools) {
        [temp addObject:i.SchoolId];
        isHasSchoolId = YES;
    }
    if (isHasSchoolId)
    {
        //NSString *string = [temp componentsJoinedByString:@","];
        return [temp componentsJoinedByString:@","];
    }
    //string = [temp componentsJoinedByString:@","];
    return @"";
}


+(NSString *)schoolNamesWithCurrentSchool:(School *)currentSchool schools:(NSArray *)schools
{
    NSString *string = nil;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    
    for (School *item in schools) {
        if ([item.Province rangeOfString:currentSchool.Province].length > 0) {
            [temp addObject:item.Name];
        }
    }
    string = [temp componentsJoinedByString:@","];
    return string;
}

+(NSString *)schoolNamesCountWithCurrentSchool:(School *)currentSchool schools:(NSArray *)schools
{
    int count = 0;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    
    for (School *item in schools) {
        if ([item.Province rangeOfString:currentSchool.Province].length > 0) {
            [temp addObject:item.Name];
            count++;
        }
    }
    if (count > 0)
    {
        return [NSString stringWithFormat:@"已选%d个",count];
    }
    return @"";

}

+(NSString*)allCodeKeyWithBaseCodeArray:(NSArray*)array
{
    BOOL isHaseCode = NO;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (BaseCode *i in array)
    {
        [temp addObject:i.CodeKey];
        isHaseCode = YES;
    }
    if (isHaseCode)
    {
        return [temp componentsJoinedByString:@","];
    }
    return @"";
}

+(NSString*)formatResumeDetail:(NSString*)degree school:(NSString*)school major:(NSString*)major
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (degree && ![degree isEqualToString:@""])
    {
        [temp addObject:degree];
    }
    if (school && ![school isEqualToString:@""])
    {
        [temp addObject:school];
    }
    if (major && ![major isEqualToString:@""])
    {
        [temp addObject:major];
    }
    return [temp componentsJoinedByString:@"|"];
}

+(NSArray*)formatCitysDetail:(NSArray*)cityList citys:(NSString*)citys
{
    if (cityList && cityList.count > 0)
    {
        return cityList;
    }
    
    if (citys && ![citys isEqualToString:@""])
    {
        return [citys componentsSeparatedByString:@","];
    }
    return nil;
}

+(NSString*)formatCitysDetailString:(NSArray*)cityList citys:(NSString*)citys
{
    if (cityList && cityList.count > 0)
    {
        return [NSString stringWithFormat:@" - %@",[cityList componentsJoinedByString:@","]];
    }
    
    if (citys && ![citys isEqualToString:@""])
    {
        return [NSString stringWithFormat:@" - %@",citys];
    }
    
    return @"";
}

+(NSString*)formatCitysDetailString2:(NSArray*)cityList citys:(NSString*)citys
{
    if (cityList && cityList.count > 0)
    {
        return [NSString stringWithFormat:@"%@",[cityList componentsJoinedByString:@","]];
    }
    
    if (citys && ![citys isEqualToString:@""])
    {
        return citys;
    }
    
    return @"";
}


+(NSString*)fullResumeDetail:(NSString*)gender age:(NSString *)age workYear:(NSString*)workYear jobStatus:(NSString *)jobStatus
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:4];
    
    if ([gender isEqualToString:@"0"]) {
        gender = @"未知";
    }if([gender isEqualToString:@"1"]){
        gender = @"男";
    }
    else{
        gender = @"女";
    }
    [temp addObject:gender];
    
    if (age && ![age isEqualToString:@""]) {
        [temp addObject:age];
    }
    
    if (workYear && ![workYear isEqualToString:@""])
    {
        [temp addObject:workYear];
    }
    if (jobStatus && ![jobStatus isEqualToString:@""]) {
        [temp addObject:jobStatus];
    }
    
    return [temp componentsJoinedByString:@" | "];
}
+(NSString*)fullResumeDetail:(NSString*)city type:(NSString *)type function:(NSString*)function salary:(NSString *)salary
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (city && ![city isEqualToString:@""]) {
        [temp addObject:city];
    }
    
    if (type && ![type isEqualToString:@""])
    {
        [temp addObject:type];
    }
    if (salary && ![salary isEqualToString:@""]) {
        [temp addObject:salary];
    }
    if (function && ![function isEqualToString:@""]) {
        [temp addObject:function];
    }
    return [temp componentsJoinedByString:@","];
}
+(NSString*)fullResumeDetail:(NSString*)major degle:(NSString *)degle
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (major && ![major isEqualToString:@""]) {
        [temp addObject:major];
    }
    if (degle && ![degle isEqualToString:@""]) {
        [temp addObject:degle];
    }
    return [temp componentsJoinedByString:@" | "];
}
+(NSString*)jobDetailWithAddress:(NSString*)address function:(NSString *)function educationLevel:(NSString *)educationLevel age:(NSString *)age experience:(NSString*)experience time:(NSString *)time PersonNumber:(NSString *)PersonNumber
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (address && ![address isEqualToString:@""]) {
        [temp addObject:address];
    }
    if (function && ![function isEqualToString:@""]) {
        [temp addObject:function];
    }
    if (educationLevel && ![educationLevel isEqualToString:@""]) {
        [temp addObject:educationLevel];
    }
    if (PersonNumber && ![PersonNumber isEqualToString:@""]) {
        [temp addObject:PersonNumber];
    }
    if (age && ![age isEqualToString:@""]) {
        [temp addObject:age];
    }
    if (experience && ![experience isEqualToString:@""]) {
        [temp addObject:experience];
    }
    if (time && ![time isEqualToString:@""]) {
        [temp addObject:time];
    }
    return [temp componentsJoinedByString:@" | "];
}

+ (NSString *)configWithJob:(NSString *)jobName address:(NSString*)address
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (jobName && ![jobName isEqualToString:@""]) {
        [temp addObject:jobName];
    }
    if (address && ![address isEqualToString:@""]) {
        [temp addObject:address];
    }
    return [temp componentsJoinedByString:@"-"];
}
+ (NSString *)configWithCompany:(NSString *)company data:(NSString*)data
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (company && ![company isEqualToString:@""]) {
        [temp addObject:company];
    }
    if (data && ![data isEqualToString:@""]) {
        [temp addObject:data];
    }
    return [temp componentsJoinedByString:@" | "];
}

+ (NSString *)configWithMouth:(NSString *)mouth day:(NSString*)day
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (mouth && ![mouth isEqualToString:@""]) {
        [temp addObject:mouth];
    }
    if (day && ![day isEqualToString:@""]) {
        [temp addObject:day];
    }
    return [temp componentsJoinedByString:@"-"];
}

+(NSString*)formatSalary:(NSString*)salary company:(NSString*)company city:(NSString*)city
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (salary && ![salary isEqualToString:@""]) {
        [temp addObject:salary];
    }
    if (company && ![company isEqualToString:@""]) {
        [temp addObject:company];
    }
    if (city && ![city isEqualToString:@""]) {
        [temp addObject:city];
    }
    return [temp componentsJoinedByString:@"|"];
}
+ (NSString*)searchJobWithPosition:(NSString*)position City:(NSString*)city salary:(NSString*)salary property:(NSString *)property workYear:(NSString *)workYear function:(NSString *)function positionType:(NSString*)positionType
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (position && ![position isEqualToString:@""] && ![position isEqualToString:@"所有职能"]) {
        [temp addObject:position];
    }
    if (city && ![city isEqualToString:@""] && ![position isEqualToString:@"全国"]) {
        [temp addObject:city];
    }
    if (salary && ![salary isEqualToString:@""] && ![position isEqualToString:@"不限"]) {
        [temp addObject:salary];
    }
    if (property && ![property isEqualToString:@""] && ![position isEqualToString:@"不限"]) {
        [temp addObject:property];
    }
    if (workYear && ![workYear isEqualToString:@""] && ![position isEqualToString:@"不限"]) {
        [temp addObject:workYear];
    }
    if (function && ![function isEqualToString:@""]&& ![position isEqualToString:@"不限"]) {
        [temp addObject:function];
    }
    if (positionType && ![positionType isEqualToString:@""]&& ![position isEqualToString:@"不限"]) {
        [temp addObject:positionType];
    }
    return [temp componentsJoinedByString:@"+"];
}

+ (NSString *)configWithTag:(NSArray*)tagArray
{
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < tagArray.count; i++) {
        [temp addObject:tagArray[i]];
    }
    return [temp componentsJoinedByString:@","];
}

+ (NSString *)configWithTime:(NSString *)time job:(NSString*)job
{
    NSMutableArray *temp = [NSMutableArray new];
    if (time && ![time isEqualToString:@""]) {
        [temp addObject:time];
    }
    if (job && ![job isEqualToString:@""]) {
        [temp addObject:job];
    }
    return [temp componentsJoinedByString:@" | "];
}

+(NSString*)ResumeDetail:(NSString*)city nature:(NSString *)nature job:(NSString*)job salary:(NSString *)salary
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (city && ![city isEqualToString:@""]) {
        [temp addObject:city];
    }
    
    if (nature && ![nature isEqualToString:@""]) {
        [temp addObject:nature];
    }
    
    if (job && ![job isEqualToString:@""]) {
        [temp addObject:job];
    }
    
    if (salary && ![salary isEqualToString:@""]) {
        [temp addObject:salary];
    }
    return [temp componentsJoinedByString:@" / "];
}

+(NSString*)formatAddress:(NSString*)address workyear:(NSString*)workyear age:(NSString*)age
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    if (address && ![address isEqualToString:@""]) {
        [temp addObject:address];
    }
    if (workyear && ![workyear isEqualToString:@""]) {
        [temp addObject:workyear];
    }
    if (age && ![age isEqualToString:@""]) {
        [temp addObject:age];
    }
    return [temp componentsJoinedByString:@" | "];
}

@end
