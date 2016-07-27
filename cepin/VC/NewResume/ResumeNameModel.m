//
//  ResumeNameModel.m
//  cepin
//
//  Created by dujincai on 15/6/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeNameModel.h"
#import "NSDate-Utilities.h"
#import "NSString+WeiResume.h"
#import "MJExtension.h"


@implementation PracticeListDataModel

@end
@implementation ComputerListDataModel

@end

@implementation CredentialListDataModel

@end
@implementation StudyAchievementListDataModel

@end

@implementation AwardsListDataModel

@end

@implementation ProjectListDataModel
@end
@implementation WorkListDateModel


@end

@implementation EducationListDateModel
@end
@implementation StudentLeadersDataModel

@end

@implementation LanguageDataModel
@end
@implementation SkillDataModel
@end

@implementation TrainingDataModel
@end

@implementation ResumeNameModel

+ (instancetype)beanFormDic:(NSDictionary *)dic
{
    ResumeNameModel *model = [[self alloc]initWithDic:dic];
    return model;
}

-(instancetype)initWithDic:(NSDictionary *)dic
{
    return [[self class]objectWithKeyValues:dic];
//    self = [super init];
//    if (self) {
//        [self setValuesForKeysWithDictionary:dic];
//    }
//    return self;
}


-(instancetype)init
{
    if (self = [super init])
    {
        [self config];
    }
   
    return self;
}

-(void)config
{

    self.ResumeName = @"";
    self.ResumeId = @"";//	String	简历id
    self.AdditionInfo = @"";//	String	姓名
    self.Hukou = @"";//	Int	仅HR可见（1：是
    self.Keywords = @"";//	String
    self.Company = @"";//	String
    self.Mobile = @"";//	String
    self.Email = @"";//	String
    self.Industry = @"";//	String
    self.Degree = @"";//	String
    self.SchoolId = @"";//	String
    self.School = @"";//	String
    self.WorkYear = @"";//	String
    self.Major = @"";//	String	专业
    self.Gender = [NSNumber numberWithInt:1];
    self.IsSendCustomer = @"1";
    self.Address = @"";//	String
    self.RevisedDate = @"";//	String	修
    self.Region = @"";
//    NSDate *date = [NSDate date];
//    NSString *strData = [date stringyyyyMMddFromDate];
//    NSArray *dataArray = [strData componentsSeparatedByString:@"-"];
//    NSString *year = [NSString stringWithFormat:@"%d",([dataArray[0] intValue]-22)];
  //  @"2010/05/02 00:00:00"
    self.Birthday = @"";
    self.GraduateDate = @""; //毕业时间
    self.AvailableType = @"";
}


@end
