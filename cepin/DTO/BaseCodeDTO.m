//
//  BaseCode.m
//  cepin
//
//  Created by ricky.tang on 14+10+14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseCodeDTO.h"
#import "JSONModel+Sqlite.h"
#import "JSONModelSqlString.h"

static NSString *const SalaryPlist = @"SalaryPlist.plist";
static NSString *const SalarySecondPlist = @"SalaryPlistSecond.plist";
static NSString *const EmployTypePlist = @"EmployTypePlist.plist";
static NSString *const CompanyNaturePlist = @"CompanyNaturePlist.plist";

NSString *pathOfFile(NSString *fileName){
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
}

NSMutableArray *fileData(NSString *fileName){
    NSArray *temp = [[NSArray alloc] initWithContentsOfFile:pathOfFile(fileName)];
    return [BaseCode arrayOfModelsFromDictionaries:temp];
}


@implementation BaseCode
+(NSInteger)userDBIndex
{
    return 1;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.CodeKey = [aDecoder decodeObjectForKey:@"CodeKey"];
        self.Level = [aDecoder decodeObjectForKey:@"Level"];
        self.PathCode = [aDecoder decodeObjectForKey:@"PathCode"];
        self.SortNumber = [aDecoder decodeObjectForKey:@"SortNumber"];
        self.CodeType = [aDecoder decodeObjectForKey:@"CodeType"];
        self.CodeName = [aDecoder decodeObjectForKey:@"CodeName"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_CodeKey forKey:@"CodeKey"];
    [aCoder encodeObject:_Level forKey:@"Level"];
    [aCoder encodeObject:_PathCode forKey:@"PathCode"];
    [aCoder encodeObject:_SortNumber forKey:@"SortNumber"];
    [aCoder encodeObject:_CodeType forKey:@"CodeType"];
    [aCoder encodeObject:_CodeName forKey:@"CodeName"];
}
+(NSMutableArray *)workYears
{
    return [BaseCode searchWithWhere:@"CodeType = \"WorkYear\"" order:@"SortNumber"];
}
+(NSMutableArray *)degrees
{
    return [BaseCode searchWithWhere:@"CodeType = \"Degree\"" order:@"SortNumber"];
}
+(NSMutableArray *)companySize
{
    return [BaseCode searchWithWhere:@"CodeType = \"CompanySize\"" order:@"SortNumber"];
}
+(NSMutableArray *)companyNature
{
    return [BaseCode searchWithWhere:@"CodeType = \"CompanyNature\"" order:@"SortNumber"];
    //return fileData(CompanyNaturePlist);
}
+(NSMutableArray *)languages
{
    return [BaseCode searchWithWhere:@"CodeType = \"Language\"" order:@"SortNumber"];
}
+(NSMutableArray *)skillLevel
{
    return [BaseCode searchWithWhere:@"CodeType = \"SkillLevel\"" order:@"SortNumber"];
}
+(NSMutableArray *)salary
{
    return fileData(SalaryPlist);
}
//查询薪金(如果是兼职和实习)
+(NSMutableArray *)secondSalary
{
    return fileData(SalarySecondPlist);
}
+(NSMutableArray *)employType
{
   return fileData(EmployTypePlist);
}
//查询一级职能
+(NSMutableArray *)jobFunction
{
    return [BaseCode searchWithWhere:@"CodeType = \"JobFunction\" AND Level = 1" order:@"SortNumber"];
}
+(NSMutableArray *)secondLevelJobFunctionWithPathCode:(NSString *)pathCode
{
    if (!pathCode || [pathCode isEqualToString:@""])
    {
        return nil;
    }
    return [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeType = \"JobFunction\" AND Level = 2 AND PathCode LIKE \"%@%@%@\"",@"%",pathCode,@"%"] order:@"SortNumber"];
}
+(NSMutableArray *)thirdLevelJobFunctionWithPathCode:(NSString *)pathCode
{
    if (!pathCode || [pathCode isEqualToString:@""])
    {
        return nil;
    }
    return [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeType = \"JobFunction\" AND Level = 3 AND PathCode LIKE \"%@%@%@\"",@"%",pathCode,@"%"] order:@"SortNumber"];
}
+(NSMutableArray *)searchJobFunctionWithPathCode:(NSString *)pathcode
{
    return [BaseCode searchWithWhere:[NSString stringWithFormat:@"PathCode = \"%@\"",pathcode] order:@"SortNumber"];
}
+(NSMutableArray *)companyDevelopment
{
    return [BaseCode searchWithWhere:@"CodeType = \"CompanyDevelopment\"" order:@"SortNumber"];
}
+(NSMutableArray *)studentLeaders
{
    return [BaseCode searchWithWhere:@"CodeType = \"StudentLeaders\"" order:@"SortNumber"];
}
+(NSMutableArray *)salaryFloatRate
{
    return [BaseCode searchWithWhere:@"CodeType = \"SalaryFloatRate\"" order:@"SortNumber"];
}
+(NSMutableArray *)award
{
    return [BaseCode searchWithWhere:@"CodeType = \"Award\"" order:@"SortNumber"];
}
+(NSMutableArray *)politics
{
    return [BaseCode searchWithWhere:@"CodeType = \"Politics\"" order:@"SortNumber"];
}
+(NSMutableArray *)studyAchievement
{
    return [BaseCode searchWithWhere:@"CodeType = \"StudyAchievement\"" order:@"SortNumber"];
}
+(NSMutableArray *)computerLevel
{
    return [BaseCode searchWithWhere:@"CodeType = \"ComputerLevel\"" order:@"SortNumber"];
}
+(NSMutableArray *)majorWithName:(NSString *)name;
{
    if (!name || [name isEqualToString:@""])
    {
        return nil;
    }
    return [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeType = \"Major\" AND CodeName like \"%@%@%@\"",@"%",name,@"%"] order:nil];
}
//学科搜索
+(NSMutableArray *)majorWithFullName:(NSString*)name
{
    if (!name || [name isEqualToString:@""])
    {
        return nil;
    }
    return [BaseCode searchWithWhere: [NSString stringWithFormat:@"CodeName = \"%@\"",name] order:nil];
}
+(BaseCode *)jobFunctionWithString:(NSString *)name
{
    if (!name || [name isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *array = [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeType = \"JobFunction\" AND CodeName = \"%@\"",name]order:nil];
    
    if (array && array.count > 0)
    {
        return array[0];
    }
    else
    {
        return  nil;
    }
    
    //return [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeType = \"JobFunction\" AND CodeName = \"%@\"",name]order:nil][0];
}
//专业搜索
+(NSMutableArray *)DegreeWithFullName:(NSString *)name
{
    if (!name || [name isEqualToString:@""])
    {
        return nil;
    }
    return [BaseCode searchWithWhere: [NSString stringWithFormat:@"CodeName = \"%@\"",name] order:nil];
}
+ (NSMutableArray *)AllMajor
{
//    return [BaseCode searchWithWhere:@"CodeType = \"Major\"" order:@"SortNumber"];
    return [BaseCode searchWithWhere:@"CodeType = \"Major\"" order:@"LENGTH(CodeName)"];
}
+(NSMutableArray *)major
{
    return [BaseCode searchWithWhere:@"CodeType = \"Major\" AND Level = 1" order:@"SortNumber"];
}
+(NSMutableArray *)secondLevelMajorWithPathCode:(NSString *)pathCode
{
    if (!pathCode || [pathCode isEqualToString:@""])
    {
        return nil;
    }
    return [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeType = \"Major\" AND Level = 2 PathCode LIKE \"%@%@%@\"",@"%",pathCode,@"%"] order:@"SortNumber"];
}
+(NSMutableArray *)thirdLevelMajorWithPathCode:(NSString *)pathCode
{
    return [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeType = \"Major\" AND Level = 3 PathCode LIKE \"%@%@%@\"",@"%",pathCode,@"%"] order:@"SortNumber"];
}
+(NSMutableArray *)JobStatus
{
    return [BaseCode searchWithWhere:@"CodeType = \"JobStatus\"" order:@"SortNumber"];
}
+(NSMutableArray *)Certificate
{
     return [BaseCode searchWithWhere:@"CodeType = \"Certificate\" AND Level = 3" order:@"SortNumber"];
}
//CertificateNormal  Certificate
+(NSMutableArray *)certificateNormal
{
    return [BaseCode searchWithWhere:@"CodeType = \"CertificateNormal\"" order:@"SortNumber"];
}
+(NSMutableArray *)KeyanLevel
{
    return [BaseCode searchWithWhere:@"CodeType = \"KeyanLevel\"" order:@"SortNumber"];

}
+(NSMutableArray *)keyanGroup
{
    return [BaseCode searchWithWhere:@"CodeType = \"KeyanGroup\"" order:@"SortNumber"];
}
+(NSMutableArray *)industry
{
    return [BaseCode searchWithWhere:@"CodeType = \"Industry\" AND Level = 1" order:@"SortNumber"];
}
+(NSMutableArray *)SecondLevelIndustryWithPathCode:(NSString *)pathCode
{
    if (!pathCode || [pathCode isEqualToString:@""])
    {
        return nil;
    }
    return [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeType = \"Industry\" AND Level = 2  AND PathCode LIKE \"%@%@%@\"",@"%",pathCode,@"%"] order:@"SortNumber"];
}
+(NSMutableArray *)IdCardType
{
    return [BaseCode searchWithWhere:@"CodeType = \"IdCardType\"" order:@"SortNumber"];
}
//查询工作性质（全职、兼职、实习等）
+(BaseCode*)employTypeWithCode:(NSString*)code
{
    if (!code || [code isEqualToString:@""])
    {
        return nil;
    }
    NSMutableArray *array = fileData(EmployTypePlist);
    for (int i = 0; i < [array count]; i++)
    {
        BaseCode *tm = [array objectAtIndex:i];
        if ([tm.PathCode isEqualToString:code])
        {
            return tm;
        }
    }
    return nil;
}
+(BaseCode*)salaryWithCodeAndEmployType:(NSString*)code type:(NSString*)type
{
    if (!code || [code isEqualToString:@""])
    {
        return nil;
    }
    
    NSString *tmType = nil;
    if (!type || [type isEqualToString:@""])
    {
        tmType = @"1";
    }
    else
    {
        tmType = type;
    }
    
    NSMutableArray *array = nil;
    if (tmType.intValue == 1)
    {
        array = fileData(SalaryPlist);
    }
    else
    {
        array = fileData(SalarySecondPlist);
    }
    
    for (int i = 0; i < [array count]; i++)
    {
        BaseCode *tm = [array objectAtIndex:i];
        if ([tm.PathCode isEqualToString:code])
        {
            return tm;
        }
    }
    return nil;
}
+(BaseCode*)salaryWithName:(NSString*)str
{
     NSMutableArray *array = fileData(SalaryPlist);
    for (int i = 0; i < [array count]; i++)
    {
        BaseCode *tm = [array objectAtIndex:i];
        if ([tm.CodeName isEqualToString:str])
        {
            return tm;
        }
    }
    return nil;
}
+(NSMutableArray*)baseCodeWithCodeKeys:(NSString*)str
{
    if (!str || [str isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *array = [str componentsSeparatedByString:@","];
    NSUInteger count = [array count];
    if ([[array lastObject]isEqualToString:@""])
    {
        count -= 1;
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc]init];
    for (int i = 0; i < count; i++)
    {
        if (i == 0)
        {
            NSString *tmStr = [NSString stringWithFormat:@"CodeKey = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
        else
        {
            NSString *tmStr = [NSString stringWithFormat:@" OR CodeKey = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
    }
    return [BaseCode searchWithWhere:mutableString order:@"SortNumber"];
}
+(NSMutableArray*)baseCodeWithPathCode:(NSString*)str
{
    if (!str || [str isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *array = [str componentsSeparatedByString:@","];
    NSUInteger count = [array count];
    if ([[array lastObject]isEqualToString:@""])
    {
        count -= 1;
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc]init];
    for (int i = 0; i < count; i++)
    {
        if (i == 0)
        {
            NSString *tmStr = [NSString stringWithFormat:@"PathCode = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
        else
        {
            NSString *tmStr = [NSString stringWithFormat:@" OR PathCode = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
    }
    return [BaseCode searchWithWhere:mutableString order:@"SortNumber"];
}

//根据codename(多个codename用逗号分隔)查询basecode数组
+(NSMutableArray*)baseCodeWithCodeName:(NSString*)str
{
    if (!str || [str isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *array = [str componentsSeparatedByString:@","];
    int count = [array count];
    if ([[array lastObject]isEqualToString:@""])
    {
        count -= 1;
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc]init];
    for (int i = 0; i < count; i++)
    {
        if (i == 0)
        {
            NSString *tmStr = [NSString stringWithFormat:@"CodeName = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
        else
        {
            NSString *tmStr = [NSString stringWithFormat:@" OR CodeName = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
    }
    return [BaseCode searchWithWhere:mutableString order:@"SortNumber"];
}

+(NSMutableArray*)baseWithCodeKey:(NSString*)str
{
      return [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeKey = \"%@\"",str] order:@"SortNumber"];
}
//根据codekey(多个codetype用逗号分隔)查询basecode数组
+(NSMutableArray*)baseWithCodeType:(NSString*)str
{
    return [BaseCode searchWithWhere:[NSString stringWithFormat:@"CodeType = \"WorkYear\" AND CodeKey = \"%@\"",str] order:@"SortNumber"];
}
@end
