//
//  RTNetworking+Resume.m
//  cepin
//
//  Created by peng on 14-11-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking+Resume.h"

@implementation RTNetworking (Resume)

// 3.5.1获得所有微简历接口
-(RACSignal *)getResumeListWithTokenId:(NSString *)tokenId userId:(NSString *)userId ResumeType:(NSString *)ResumeType
{
    return [self.httpManager rac_GET:@"Resume/List" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeType":ResumeType}];
}
-(RACSignal *)toTopWithResumeId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId
{
    return [self.httpManager rac_POST:@"Resume/SetResumeTop" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":resumeId}];
}
-(RACSignal *)deleteWithResumeId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId
{
    return [self.httpManager rac_POST:@"Resume/DeleteResume" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":resumeId}];
}
-(RACSignal *)copyWithResumeId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId
{
    return [self.httpManager rac_GET:@"ThridEdition/Resume/CopyResumeInfo" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":resumeId}];
}
-(RACSignal *)getResumeDetailWithResumeId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId
{
    return [self.httpManager rac_POST:@"Resume/GetResumeInfo" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":resumeId}];
}
-(RACSignal *)editRessume:(NSDictionary*)postDic
{
    return [self.httpManager rac_POST:@"Resume/UpdateMicroResume" parameters:postDic];
}
-(RACSignal *)addAward:(NSDictionary*)postDic
{
    return [self.httpManager rac_POST:@"Resume/AddAward" parameters:postDic];
}
-(RACSignal *)addSkill:(NSDictionary*)postDic
{
    return [self.httpManager rac_POST:@"Resume/AddSkill" parameters:postDic];
}
-(RACSignal *)addExp:(NSDictionary*)postDic
{
    return [self.httpManager rac_POST:@"Resume/AddWorkExp" parameters:postDic];
}

-(RACSignal *)editExp:(NSDictionary*)postDic
{
    return [self.httpManager rac_POST:@"Resume/UpdateWorkExp" parameters:postDic];
}

-(RACSignal *)editAward:(NSDictionary*)postDic
{
    return [self.httpManager rac_POST:@"Resume/UpdateAward" parameters:postDic];
}

-(RACSignal *)deleteExp:(NSString *)tokenId userId:(NSString *)userId ResumeId:(NSString*)ResumeId ExperienceId:(NSString*)ExperienceId
{
    return [self.httpManager rac_GET:@"Resume/DeleteWorkExp" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":ResumeId,@"ExperienceId":ExperienceId}];
}

-(RACSignal *)deleteSkill:(NSString *)tokenId userId:(NSString *)userId ResumeId:(NSString*)ResumeId SkillId:(NSString*)SkillId
{
    return [self.httpManager rac_GET:@"Resume/DeleteSkill" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":ResumeId,@"SkillId":SkillId}];
}

-(RACSignal *)deleteAward:(NSString *)tokenId userId:(NSString *)userId ResumeId:(NSString*)ResumeId HonourId:(NSString*)HonourId
{
    return [self.httpManager rac_GET:@"Resume/DeleteAward" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":ResumeId,@"HonourId":HonourId}];
}

-(RACSignal *)editSkill:(NSDictionary*)postDic
{
    return [self.httpManager rac_POST:@"Resume/UpdateSkill" parameters:postDic];
}

// 3.5.2添加微简历接口
-(RACSignal *)addResumeWithTokenId:(NSString *)tokenId userId:(NSString *)userId ResumeName:(NSString *)ResumeName ChineseName:(NSString *)ChineseName School:(NSString *)School SchoolId:(NSString *)SchoolId Major:(NSString *)Major MajorKey:(NSString *)MajorKey GraduateDate:(NSString *)GraduateDate Gender:(NSString *)Gender UserRemark:(NSString *)UserRemark Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey
{
    return [self.httpManager rac_POST:@"Resume/Add" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeName":ResumeName,@"ChineseName":ChineseName,@"School":School,@"SchoolId":SchoolId,@"Major":Major,@"MajorKey":MajorKey,@"GraduateDate":GraduateDate,@"Gender":Gender,@"UserRemark":UserRemark,@"Degree":Degree,@"DegreeKey":DegreeKey}];
}

// 3.5.3修改微简历接口
-(RACSignal *)updateResumeWithTokenId:(NSString *)tokenId userId:(NSString *)userId ResumeId:(NSString *)ResumeId ResumeName:(NSString *)ResumeName ChineseName:(NSString *)ChineseName School:(NSString *)School SchoolId:(NSString *)SchoolId Major:(NSString *)Major MajorKey:(NSString *)MajorKey GraduateDate:(NSString *)GraduateDate Gender:(NSString *)Gender UserRemark:(NSString *)UserRemark Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey
{
    return [self.httpManager rac_POST:@"Resume/Update" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":ResumeId,@"ResumeName":ResumeName,@"ChineseName":ChineseName,@"School":School,@"SchoolId":SchoolId,@"Major":Major,@"MajorKey":MajorKey,@"GraduateDate":GraduateDate,@"Gender":Gender,@"UserRemark":UserRemark,@"Degree":Degree,@"DegreeKey":DegreeKey}];
    
}

// 3.9.1 投递简历接口
-(RACSignal *)resumeDeliveryWithUserId:(NSString *)userId tokenId:(NSString *)tokenId positionId:(NSString *)positionId resumeId:(NSString *)resumeId
{
    return [self.httpManager rac_POST:@"Resume/Delivery" parameters:@{@"userId":userId,@"tokenId":tokenId,@"positionId":positionId,@"resumeId":resumeId}];
}

// 3.9.2 投递简历列表接口
-(RACSignal *)getResumeDeliveriedListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize
{
    return [self.httpManager rac_GET:@"Resume/DeliveriedList" parameters:@{@"tokenId":tokenId,@"userId":userId,@"PageIndex":@(PageIndex),@"PageSize":@(PageSize)}];
}

//简历预览
-(RACSignal *)getResumePreviewWithTokenId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId
{
    return [self.httpManager rac_POST:@"Resume/GetFullResumeInfo" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":resumeId}];
}


-(RACSignal *)addThridRessume:(NSString *)userId tokenId:(NSString *)tokenId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/CreateResumeInfo" parameters:@{@"userId":userId,@"tokenId":tokenId}];
}
-(RACSignal *)addRessume:(NSDictionary *)postDic
{
    return [self.httpManager rac_GET:@"ThridEdition/Resume/EditBaseInfo" parameters:postDic];
    
}

//编辑基本信息
-(RACSignal *)addThridRessumeWith:(NSString*)ResumeName ChineseName:(NSString*)ChineseName Gender:(NSString*)Gender Email:(NSString*)Email Mobile:(NSString*)Mobile Birthday:(NSString*)Birthday Region:(NSString*)Region WorkYear:(NSString*)WorkYear IsSendCustomer:(NSString*)IsSendCustomer RegionCode:(NSString*)RegionCode WorkYearKey:(NSString*)WorkYearKey ResumeId:(NSString*)ResumeId userId:(NSString *)userId tokenId:(NSString *)tokenId JobStatus:(NSString*)JobStatus Politics:(NSString*)Politics PoliticsKey:(NSString*)PoliticsKey Hukou:(NSString*)Hukou HukouKey:(NSString*)HukouKey IdCardNumber:(NSString*)IdCardNumber GraduateDate:(NSString*)GraduateDate Address:(NSString*)Address Marital:(NSString*)Marital Introduces:(NSString *)Introduces
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/EditBaseInfo" parameters:@{@"ResumeName":ResumeName,@"ChineseName":ChineseName,@"Gender":Gender,@"Email":Email,@"Mobile":Mobile,@"Birthday":Birthday,@"Region":Region,@"WorkYear":WorkYear,@"IsSendCustomer":IsSendCustomer,@"RegionCode":RegionCode,@"WorkYearKey":WorkYearKey,@"ResumeId":ResumeId,@"userId":userId,@"tokenId":tokenId,@"JobStatus":JobStatus,@"Politics":Politics,@"PoliticsKey":PoliticsKey,@"Hukou":Hukou,@"HukouKey":HukouKey,@"IdCardNumber":IdCardNumber,@"GraduateDate":GraduateDate,@"Address":Address,@"Marital":Marital, @"Introduces" : [NSString stringWithFormat:@"%@", Introduces]}];
}
//编辑校招基本信息
-(RACSignal *)addThridRessumeWith:(NSString*)ResumeName ChineseName:(NSString*)ChineseName Gender:(NSString*)Gender Email:(NSString*)Email Mobile:(NSString*)Mobile Birthday:(NSString*)Birthday Region:(NSString*)Region WorkYear:(NSString*)WorkYear IsSendCustomer:(NSString*)IsSendCustomer RegionCode:(NSString*)RegionCode WorkYearKey:(NSString*)WorkYearKey ResumeId:(NSString*)ResumeId userId:(NSString *)userId tokenId:(NSString *)tokenId JobStatus:(NSString*)JobStatus Politics:(NSString*)Politics PoliticsKey:(NSString*)PoliticsKey Hukou:(NSString*)Hukou HukouKey:(NSString*)HukouKey IdCardNumber:(NSString*)IdCardNumber GraduateDate:(NSString*)GraduateDate Address:(NSString*)Address Marital:(NSString*)Marital QQ:(NSString *)QQ Nation:(NSString *)Nation Weight:(NSString *)Weight HealthType:(NSString *)HealthType Height:(NSString *)Height NativeCity:(NSString *)NativeCity NativeCityKey:(NSString *)NativeCityKey EmergencyContact:(NSString *)EmergencyContact EmergencyContactPhone:(NSString *)EmergencyContactPhone ZipCode:(NSString *)ZipCode Health:(NSString *)Health
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/EditBaseInfo" parameters:@{@"ResumeName":ResumeName,@"ChineseName":ChineseName,@"Gender":Gender,@"Email":Email,@"Mobile":Mobile,@"Birthday":Birthday,@"Region":Region,@"WorkYear":WorkYear,@"IsSendCustomer":IsSendCustomer,@"RegionCode":RegionCode,@"WorkYearKey":WorkYearKey,@"ResumeId":ResumeId,@"userId":userId,@"tokenId":tokenId,@"JobStatus":JobStatus,@"Politics":Politics,@"PoliticsKey":PoliticsKey,@"Hukou":Hukou,@"HukouKey":HukouKey,@"IdCardNumber":IdCardNumber,@"GraduateDate":GraduateDate,@"Address":Address,@"Marital":Marital,@"QQ":QQ,@"Nation":Nation,@"Weight":Weight,@"HealthType":HealthType,@"Height":Height,@"NativeCity":NativeCity,@"NativeCityKey":NativeCityKey,@"EmergencyContact":EmergencyContact,@"EmergencyContactPhone":EmergencyContactPhone,@"ZipCode":ZipCode,@"Health":Health}];
}
//编辑基本信息简历引导
-(RACSignal *)addThridRessumeWith:(NSString*)ResumeName ChineseName:(NSString*)ChineseName Gender:(NSString*)Gender Email:(NSString*)Email Mobile:(NSString*)Mobile Birthday:(NSString*)Birthday Region:(NSString*)Region WorkYear:(NSString*)WorkYear IsSendCustomer:(NSString*)IsSendCustomer RegionCode:(NSString*)RegionCode WorkYearKey:(NSString*)WorkYearKey ResumeId:(NSString*)ResumeId userId:(NSString *)userId tokenId:(NSString *)tokenId JobStatus:(NSString *)JobStatus ResumeType:(NSString*)resumeType Introduces:(NSString *)Introduces idCardNumber:(NSString *)idCardNumber;
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/EditBaseInfo" parameters:@{@"ResumeName":ResumeName,@"ChineseName":ChineseName,@"Gender":Gender,@"Email":Email,@"Mobile":Mobile,@"Birthday":Birthday,@"Region":Region,@"WorkYear":WorkYear,@"IsSendCustomer":IsSendCustomer,@"RegionCode":RegionCode,@"WorkYearKey":WorkYearKey,@"ResumeId":ResumeId,@"userId":userId,@"tokenId":tokenId,@"JobStatus":JobStatus,@"ResumeType":resumeType, @"Introduces" : [NSString stringWithFormat:@"%@", Introduces], @"IdCardNumber" : idCardNumber}];
}
//3.1创建基础信息的校招简历
-(RACSignal *)addThridRessumeWithSchoolResume:(NSString *)ResumeName ChineseName:(NSString *)ChineseName Gender:(NSString *)Gender Email:(NSString *)Email Mobile:(NSString *)Mobile Birthday:(NSString *)Birthday Region:(NSString *)Region WorkYear:(NSString *)WorkYear IsSendCustomer:(NSString *)IsSendCustomer RegionCode:(NSString *)RegionCode WorkYearKey:(NSString *)WorkYearKey ResumeId:(NSString *)ResumeId userId:(NSString *)userId tokenId:(NSString *)tokenId JobStatus:(NSString *)JobStatus ResumeType:(NSString *)resumeType Weight:(NSString *)Weight HealthType:(NSString *)HealthType Height:(NSString *)Height Nation:(NSString *)Nation NativeCity:(NSString *)NativeCity GraduateDate:(NSString *)GraduateDate Politics:(NSString *)Politics NativeCityKey:(NSString*)NativeCityKey PoliticsKey:(NSString*)PoliticsKey Health:(NSString *)Health idCardNumber:(NSString *)idCardNumber
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/EditBaseInfo" parameters:@{@"ResumeName":ResumeName,@"ChineseName":ChineseName,@"Gender":Gender,@"Email":Email,@"Mobile":Mobile,@"Birthday":Birthday,@"Region":Region,@"WorkYear":WorkYear,@"IsSendCustomer":IsSendCustomer,@"RegionCode":RegionCode,@"WorkYearKey":WorkYearKey,@"ResumeId":ResumeId,@"userId":userId,@"tokenId":tokenId,@"JobStatus":JobStatus,@"ResumeType":resumeType,@"Weight":Weight,@"HealthType":HealthType,@"Height":Height,@"Nation":Nation,@"NativeCity":NativeCity,@"GraduateDate":GraduateDate,@"Politics":Politics,@"NativeCityKey":NativeCityKey ,@"PoliticsKey":PoliticsKey,@"Health":Health, @"IdCardNumber" : idCardNumber}];
}
- (RACSignal *)checkIsExistEmail:(NSString *)email tokenID:(NSString *)tokenID userID:(NSString *)userID
{
    return [self.httpManager rac_GET:@"/ThridEdition/Resume/IsExistEmail" parameters:@{ @"Email" : email, @"tokenID" : tokenID, @"userID" : userID }];
}
- (RACSignal *)sendBindEmail:(NSString *)email tokenID:(NSString *)tokenID userID:(NSString *)userID
{
    return [self.httpManager rac_POST:@"/User/EditEmail" parameters:@{ @"Email" : email, @"tokenID" : tokenID, @"userID" : userID }];
}
-(RACSignal *)addThridRessume:(NSDictionary*)postDic
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/EditBaseInfo" parameters:postDic];
}
-(RACSignal *)getThridResumeDetailWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString *)tokenId
{
    return [self.httpManager rac_GET:@"ThridEdition/Resume/GetResumeInfo" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId}];
}
-(RACSignal *)addThridResumeKeyWordWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString *)tokenId keyWords:(NSString*)keyWords
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/EditKeyWords" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"keyWords":keyWords}];
}
//期望工作
-(RACSignal *)saveThridExpectJobWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId ExpectCity:(NSString*)ExpectCity ExpectIndustry:(NSString*)ExpectIndustry ExpectEmployType:(NSString*)ExpectEmployType ExpectSalary:(NSString*)ExpectSalary;
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/EditExpectWork" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"ExpectCity":ExpectCity,@"ExpectJobFunction":ExpectIndustry,@"ExpectEmployType":ExpectEmployType,@"ExpectSalary":ExpectSalary}];
}
//3.1校招期望工作
-(RACSignal *)saveThridExpectJobWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString *)tokenId ExpectCity:(NSString *)ExpectCity ExpectIndustry:(NSString *)ExpectIndustry ExpectEmployType:(NSString *)ExpectEmployType ExpectSalary:(NSString *)ExpectSalary AvailableType:(NSString *)AvailableType IsAllowDistribution:(NSString *)IsAllowDistribution
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/EditExpectWork" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"ExpectCity":ExpectCity,@"ExpectJobFunction":ExpectIndustry,@"ExpectEmployType":ExpectEmployType,@"ExpectSalary":ExpectSalary,@"AvailableType":AvailableType,@"IsAllowDistribution":IsAllowDistribution}];
}
-(RACSignal *)addThridResumeJobStatusWithUserId:(NSString *)userId tokenId:(NSString *)tokenId workStatusCode:(NSString*)workStatusCode
{
        return [self.httpManager rac_POST:@"ThridEdition/Resume/EditWorkStatus" parameters:@{@"userId":userId,@"workStatusCode":workStatusCode,@"tokenId":tokenId}];
}
-(RACSignal *)getThridResumeWorkListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId
{
    return [self.httpManager rac_GET:@"ThridEdition/Resume/GetResumeWorkList" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId}];
}
-(RACSignal *)deleteThridResumeWorkListWithResumeId:(NSString *)resumeId workId:(NSString*)workId userId:(NSString *)userId tokenId:(NSString*)tokenId
{
       return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumeWork" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"workId":workId}];
}
-(RACSignal *)getThridResumeWorkListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumeWork" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}
-(RACSignal *)saveThridWorkStartDate:(NSString *)StartDate userId:(NSString *)userId tokenId:(NSString *)tokenId EndDate:(NSString *)EndDate Nature:(NSString *)Nature Size:(NSString *)Size Industry:(NSString *)Industry JobCity:(NSString *)JobCity JobFunction:(NSString *)JobFunction Content:(NSString *)Content Salary:(NSString *)Salary CompanyRanking:(NSString *)CompanyRanking ResumeId:(NSString *)ResumeId Id:(NSString *)Id NatureKey:(NSString *)NatureKey IndustryKey:(NSString *)IndustryKey JobCityKey:(NSString *)JobCityKey JobFunctionKey:(NSString *)JobFunctionKey SizeKey:(NSString *)SizeKey Company:(NSString *)Company IsAbroad:(NSString *)IsAbroad
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeWork" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Nature":Nature,@"Size":Size,@"Industry":Industry,@"JobCity":JobCity,@"JobFunction":JobFunction,@"Content":Content,@"Salary":Salary,@"CompanyRanking":CompanyRanking,@"ResumeId":ResumeId,@"Id":Id,@"NatureKey":NatureKey,@"IndustryKey":IndustryKey,@"JobCityKey":JobCityKey,@"JobFunctionKey":JobFunctionKey,@"SizeKey":SizeKey,@"Company":Company,@"IsAbroad":IsAbroad}];
}

-(RACSignal *)saveThridWorkStartDate:(NSString *)StartDate userId:(NSString *)userId tokenId:(NSString *)tokenId EndDate:(NSString *)EndDate Nature:(NSString *)Nature Size:(NSString *)Size Industry:(NSString *)Industry JobCity:(NSString *)JobCity JobFunction:(NSString *)JobFunction Content:(NSString *)Content Salary:(NSString *)Salary CompanyRanking:(NSString *)CompanyRanking ResumeId:(NSString *)ResumeId Id:(NSString *)Id NatureKey:(NSString *)NatureKey IndustryKey:(NSString *)IndustryKey JobCityKey:(NSString *)JobCityKey JobFunctionKey:(NSString *)JobFunctionKey SizeKey:(NSString *)SizeKey Company:(NSString *)Company IsAbroad:(NSString *)IsAbroad AttestorName:(NSString *)AttestorName AttestorRelation:(NSString *)AttestorRelation AttestorPosition:(NSString *)AttestorPosition AttestorCompany:(NSString *)AttestorCompany AttestorPhone:(NSString *)AttestorPhone
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeWork" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Nature":Nature,@"Size":Size,@"Industry":Industry,@"JobCity":JobCity,@"JobFunction":JobFunction,@"Content":Content,@"Salary":Salary,@"CompanyRanking":CompanyRanking,@"ResumeId":ResumeId,@"Id":Id,@"NatureKey":NatureKey,@"IndustryKey":IndustryKey,@"JobCityKey":JobCityKey,@"JobFunctionKey":JobFunctionKey,@"SizeKey":SizeKey,@"Company":Company,@"IsAbroad":IsAbroad,@"AttestorName":AttestorName,@"AttestorRelation":AttestorRelation, @"AttestorPosition":AttestorPosition, @"AttestorCompany":AttestorCompany,@"AttestorPhone":AttestorPhone}];
}


-(RACSignal *)saveThridWorkStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Nature:(NSString*)Nature Size:(NSString*)Size Industry:(NSString*)Industry JobCity:(NSString*)JobCity JobFunction:(NSString*)JobFunction Content:(NSString*)Content Salary:(NSString*)Salary CompanyRanking:(NSString*)CompanyRanking ResumeId:(NSString*)ResumeId NatureKey:(NSString*)NatureKey IndustryKey:(NSString*)IndustryKey JobCityKey:(NSString*)JobCityKey JobFunctionKey:(NSString*)JobFunctionKey SizeKey:(NSString*)SizeKey Company:(NSString*)Company IsAbroad:(NSString *)IsAbroad
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeWork" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Nature":[NSString stringWithFormat:@"%@", Nature],@"Size":Size,@"Industry":Industry,@"JobCity":JobCity,@"JobFunction":[NSString stringWithFormat:@"%@", JobFunction],@"Content":Content,@"Salary":Salary,@"CompanyRanking":CompanyRanking,@"ResumeId":ResumeId,@"NatureKey":[NSString stringWithFormat:@"%@", NatureKey],@"IndustryKey":IndustryKey,@"JobCityKey":JobCityKey,@"JobFunctionKey":[NSString stringWithFormat:@"%@", JobFunctionKey],@"SizeKey":SizeKey,@"Company":Company,@"IsAbroad":IsAbroad}];
}

//3.1编辑校招实习经历
-(RACSignal *)saveThridWorkStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Nature:(NSString*)Nature Size:(NSString*)Size Industry:(NSString*)Industry JobCity:(NSString*)JobCity JobFunction:(NSString*)JobFunction Content:(NSString*)Content Salary:(NSString*)Salary CompanyRanking:(NSString*)CompanyRanking ResumeId:(NSString*)ResumeId NatureKey:(NSString*)NatureKey IndustryKey:(NSString*)IndustryKey JobCityKey:(NSString*)JobCityKey JobFunctionKey:(NSString*)JobFunctionKey SizeKey:(NSString*)SizeKey Company:(NSString*)Company IsAbroad:(NSString *)IsAbroad AttestorName:(NSString *)AttestorName AttestorRelation:(NSString *)AttestorRelation AttestorPosition:(NSString *)AttestorPosition AttestorCompany:(NSString *)AttestorCompany AttestorPhone:(NSString *)AttestorPhone
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeWork" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Nature":Nature,@"Size":Size,@"Industry":Industry,@"JobCity":JobCity,@"JobFunction":JobFunction,@"Content":Content,@"Salary":Salary,@"CompanyRanking":CompanyRanking,@"ResumeId":ResumeId,@"NatureKey":NatureKey,@"IndustryKey":IndustryKey,@"JobCityKey":JobCityKey,@"JobFunctionKey":JobFunctionKey,@"SizeKey":SizeKey,@"Company":Company,@"IsAbroad":IsAbroad,@"AttestorName":AttestorName,@"AttestorRelation":AttestorRelation, @"AttestorPosition":AttestorPosition, @"AttestorCompany":AttestorCompany,@"AttestorPhone":AttestorPhone}];
}
-(RACSignal *)getThridResumeEducationListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumeEduList" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId}];
}
- (RACSignal *)deleteThridResumeEducationListWithResumeId:(NSString *)resumeId eduId:(NSString *)eduId userId:(NSString *)userId tokenId:(NSString *)tokenId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumeEdu" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"eduId":eduId}];
}
- (RACSignal *)getThridResumeEducationListWithResumeId:(NSString *)resumeId Id:(NSString *)Id userId:(NSString *)userId tokenId:(NSString *)tokenId
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumeEdu" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}
-(RACSignal *)saveThridEducationStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate SchoolCode:(NSString*)SchoolCode School:(NSString*)School Major:(NSString*)Major MajorKey:(NSString*)MajorKey Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey ResumeId:(NSString*)ResumeId Id:(NSString*)Id
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeEdu" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"SchoolCode":SchoolCode,@"School":School,@"Major":Major,@"MajorKey":MajorKey,@"Degree":Degree,@"DegreeKey":DegreeKey,@"ResumeId":ResumeId,@"Id":Id}];
}
-(RACSignal *)saveThridEducationStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate SchoolCode:(NSString*)SchoolCode School:(NSString*)School Major:(NSString*)Major MajorKey:(NSString*)MajorKey Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey ResumeId:(NSString*)ResumeId Id:(NSString*)Id ScoreRanking:(NSString *)ScoreRanking Xuewei:(NSString *)Xuewei Description:(NSString *)Description
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeEdu" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"SchoolCode":SchoolCode,@"School":School,@"Major":Major,@"MajorKey":MajorKey,@"Degree":Degree,@"DegreeKey":DegreeKey,@"ResumeId":ResumeId,@"Id":Id,@"ScoreRanking":ScoreRanking,@"Xuewei":Xuewei,@"Description":Description}];
}
-(RACSignal *)addThridEducationStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate SchoolCode:(NSString*)SchoolCode School:(NSString*)School Major:(NSString*)Major MajorKey:(NSString*)MajorKey Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey ResumeId:(NSString*)ResumeId
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeEdu" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"SchoolCode":SchoolCode,@"School":School,@"Major":Major,@"MajorKey":MajorKey,@"Degree":Degree,@"DegreeKey":DegreeKey,@"ResumeId":ResumeId}];
}
//3.1添加校招教育经历
-(RACSignal *)addThridEducationStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate SchoolCode:(NSString*)SchoolCode School:(NSString*)School Major:(NSString*)Major MajorKey:(NSString*)MajorKey Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey ResumeId:(NSString*)ResumeId ScoreRanking:(NSString *)ScoreRanking Xuewei:(NSString *)Xuewei Description:(NSString *)Description
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeEdu" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"SchoolCode":SchoolCode,@"School":School,@"Major":Major,@"MajorKey":MajorKey,@"Degree":Degree,@"DegreeKey":DegreeKey,@"ResumeId":ResumeId,@"ScoreRanking":ScoreRanking,@"EndDate":EndDate,@"Description":Description,@"Xuewei":Xuewei }];
}
//项目列表
-(RACSignal *)getThridResumeProjectListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId
{
      return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumeProjectList" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId}];
}
//删除项目列表
-(RACSignal *)deleteThridResumeProjectListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;
{
      return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumeProject" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}
//获取项目信息
-(RACSignal *)getThridResumeProjectListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumeProject" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}
//保存项目
-(RACSignal *)saveThridProjectStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Duty:(NSString*)Duty Name:(NSString*)Name KeyanLevel:(NSString*)KeyanLevel Description:(NSString*)Description Content:(NSString*)Content ResumeId:(NSString*)ResumeId Id:(NSString*)Id ProjectLink:(NSString *)ProjectLink IsKeyuan:(NSString *)IsKeyuan
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeProject" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Duty":Duty,@"Name":Name,@"KeyanLevel":KeyanLevel,@"Description":Description,@"Content":Content,@"Id":Id,@"ResumeId":ResumeId, @"ProjectLink" : ProjectLink, @"IsKeyuan" : IsKeyuan}];
}
//添加项目
-(RACSignal *)addThridProjectStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Duty:(NSString*)Duty Name:(NSString*)Name KeyanLevel:(NSString*)KeyanLevel Description:(NSString*)Description Content:(NSString*)Content ResumeId:(NSString*)ResumeId ProjectLink:(NSString *)ProjectLink IsKeyuan:(NSString *)IsKeyuan
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeProject" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Duty":Duty,@"Name":Name,@"KeyanLevel":KeyanLevel,@"Description":Description,@"Content":Content,@"ResumeId":ResumeId, @"ProjectLink" : ProjectLink, @"IsKeyuan" : IsKeyuan}];
}
//专业列表
-(RACSignal *)getThridResumeCredentialListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumeCertificateList" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId}];
}

//删除专业
-(RACSignal *)deleteThridResumeCredentialListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumeCertificate" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}

//保存专业
-(RACSignal *)saveThridCredentialDate:(NSString*)Date userId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name BaseCodeKey:(NSString*)BaseCodeKey ResumeId:(NSString*)ResumeId Id:(NSString*)Id Type:(NSString*)Type
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeCertificate" parameters:@{@"Date":Date,@"userId":userId,@"tokenId":tokenId,@"Name":Name,@"BaseCodeKey":BaseCodeKey,@"Id":Id,@"ResumeId":ResumeId,@"Type":Type}];
}

//添加专业
-(RACSignal *)addThridCredentialDate:(NSString*)Date userId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name BaseCodeKey:(NSString*)BaseCodeKey ResumeId:(NSString*)ResumeId Type:(NSString*)Type
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeCertificate" parameters:@{@"Date":Date,@"userId":userId,@"tokenId":tokenId,@"Name":Name,@"BaseCodeKey":BaseCodeKey,@"ResumeId":ResumeId,@"Type":Type}];
}

//技能列表
-(RACSignal *)getThridResumeSkillListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId
{
       return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumeSkillList" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId}];
}

//保存专业技能
-(RACSignal *)saveThridSkillUserId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name MasteryLevel:(NSString*)MasteryLevel ResumeId:(NSString*)ResumeId Id:(NSString*)Id
{
      return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeSkill" parameters:@{@"tokenId":tokenId,@"userId":userId,@"Name":Name,@"MasteryLevel":MasteryLevel,@"ResumeId":ResumeId,@"Id":Id}];
}

//添加专业技能
-(RACSignal *)addThridSkillUserId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name MasteryLevel:(NSString*)MasteryLevel ResumeId:(NSString*)ResumeId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeSkill" parameters:@{@"tokenId":tokenId,@"userId":userId,@"Name":Name,@"MasteryLevel":MasteryLevel,@"ResumeId":ResumeId}];
}

//删除技能
-(RACSignal *)deleteThridResumeSkillListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumeSkill" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}
//语言列表
-(RACSignal *)getThridResumeLanguageListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumeLanguageList" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId}];
}
//保存语言
-(RACSignal *)saveThridLanguageUserId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name BaseCodeKey:(NSString*)BaseCodeKey ResumeId:(NSString*)ResumeId Id:(NSString*)Id Writing:(NSString*)Writing Speaking:(NSString*)Speaking
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeLanguage" parameters:@{@"tokenId":tokenId,@"userId":userId,@"Name":Name,@"BaseCodeKey":BaseCodeKey,@"ResumeId":ResumeId,@"Id":Id,@"Writing":Writing,@"Speaking":Speaking}];
    
}

-(RACSignal *)saveThridEnglishUserId:(NSString *)userId tokenId:(NSString *)tokenId ResumeId:(NSString *)ResumeId IsHasCET4Score:(NSString *)IsHasCET4Score IsHasCET6Score:(NSString *)IsHasCET6Score IsHasTEM4Score:(NSString *)IsHasTEM4Score IsHasTEM8Score:(NSString *)IsHasTEM8Score IsHasIELTSScore:(NSString *)IsHasIELTSScore IsHasTOEFLScore:(NSString *)IsHasTOEFLScore CET4Score:(NSString *)CET4Score CET6Score:(NSString *)CET6Score TEM4Score:(NSString *)TEM4Score TEM8Score:(NSString *)TEM8Score TOEFLScore:(NSString *)TOEFLScore IELTSScore:(NSString*)IELTSScore{
    
    return [self.httpManager rac_POST:@"/ThridEdition/Resume/SaveResumeEnglishLevel" parameters:@{@"tokenId":tokenId,@"userId":userId,@"ResumeId":ResumeId,@"IsHasCET4Score":IsHasCET4Score,@"IsHasCET6Score":IsHasCET6Score,@"IsHasTEM4Score":IsHasTEM4Score,@"IsHasTEM8Score":IsHasTEM8Score,@"IsHasIELTSScore":IsHasIELTSScore,@"IsHasTOEFLScore":IsHasTOEFLScore,@"CET4Score":CET4Score,@"CET6Score":CET6Score,@"TEM4Score":TEM4Score,@"TEM8Score":TEM8Score,@"TOEFLScore":TOEFLScore,@"IELTSScore":IELTSScore}];

}

//添加语言
-(RACSignal *)addThridLanguageUserId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name BaseCodeKey:(NSString*)BaseCodeKey ResumeId:(NSString*)ResumeId Writing:(NSString*)Writing Speaking:(NSString*)Speaking
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeLanguage" parameters:@{@"tokenId":tokenId,@"userId":userId,@"Name":Name,@"BaseCodeKey":BaseCodeKey,@"ResumeId":ResumeId,@"Writing":Writing,@"Speaking":Speaking}];
}

//删除语言
-(RACSignal *)deleteThridResumeLanguageListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumeLanguage" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}

//实践经历列表
-(RACSignal *)getThridResumePracticeListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumePracticalList" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId}];
}

//添加实践经历
-(RACSignal *)addThridPracticeStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Title:(NSString*)Title Name:(NSString*)Name Content:(NSString*)Content ResumeId:(NSString*)ResumeId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumePractical" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Title":Title,@"Name":Name,@"Content":Content,@"ResumeId":ResumeId}];
}

//保存实践经历
-(RACSignal *)saveThridPracticeStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Title:(NSString*)Title Name:(NSString*)Name Content:(NSString*)Content ResumeId:(NSString*)ResumeId Id:(NSString*)Id
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumePractical" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Title":Title,@"Name":Name,@"Content":Content,@"ResumeId":ResumeId,@"Id":Id}];
}

//删除实践经历
-(RACSignal *)deleteThridResumePracticeListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumePractical" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}

//获取奖励列表
-(RACSignal *)getThridResumeAwardListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId type:(NSString*)type
{
       return [self.httpManager rac_POST:@"ThridEdition/Resume/GetResumeStudentExpList" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"type":type}];
}

//删除奖励列表
-(RACSignal *)deleteThridResumeAwardListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumeStudentExp" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}

//保存奖励
-(RACSignal *)saveThridAwardStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId Level:(NSString*)Level Name:(NSString*)Name ResumeId:(NSString*)ResumeId Id:(NSString*)Id type:(NSString*)type;
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeStudentExp" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"Level":Level,@"type":type,@"Name":Name,@"ResumeId":ResumeId,@"Id":Id}];
}
//添加奖励
-(RACSignal *)addThridAwardStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId Level:(NSString*)Level Name:(NSString*)Name ResumeId:(NSString*)ResumeId type:(NSString*)type
{
     return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeStudentExp" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"Level":Level,@"type":type,@"Name":Name,@"ResumeId":ResumeId}];
}

//保存学生干部
-(RACSignal *)saveThridStudentStartDate:(NSString*)StartDate EndDate:(NSString*)EndDate userId:(NSString*)userId tokenId:(NSString*)tokenId Level:(NSString*)Level Name:(NSString*)Name ResumeId:(NSString*)ResumeId Id:(NSString*)Id type:(NSString*)type
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeStudentExp" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"Level":Level,@"type":type,@"Name":Name,@"ResumeId":ResumeId,@"Id":Id,@"EndDate":EndDate}];
}
//添加学生干部
-(RACSignal *)addThridStudentStartDate:(NSString*)StartDate EndDate:(NSString*)EndDate userId:(NSString*)userId tokenId:(NSString*)tokenId Level:(NSString*)Level Name:(NSString*)Name ResumeId:(NSString*)ResumeId type:(NSString*)type
{
       return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeStudentExp" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"Level":Level,@"type":type,@"Name":Name,@"ResumeId":ResumeId,@"EndDate":EndDate}];
}

//培训列表
-(RACSignal *)getThridResumeTrainListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId
{
    return [self.httpManager rac_GET:@"ThridEdition/Resume/GetResumeTrainingList" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId}];
    
}
//删除培训
-(RACSignal *)deleteThridResumeTrainListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumeTraining" parameters:@{@"userId":userId,@"ResumeId":resumeId,@"tokenId":tokenId,@"Id":Id}];
}
//保存培训
-(RACSignal *)saveThridTrainStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Organization:(NSString*)Organization Name:(NSString*)Name Content:(NSString*)Content ResumeId:(NSString*)ResumeId Id:(NSString*)Id
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeTraining" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Organization":Organization,@"Name":Name,@"Content":Content,@"ResumeId":ResumeId,@"Id":Id}];
}
//添加
-(RACSignal *)addThridTrainStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Organization:(NSString*)Organization Name:(NSString*)Name Content:(NSString*)Content ResumeId:(NSString*)ResumeId
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeTraining" parameters:@{@"StartDate":StartDate,@"userId":userId,@"tokenId":tokenId,@"EndDate":EndDate,@"Organization":Organization,@"Name":Name,@"Content":Content,@"ResumeId":ResumeId}];
}
//保存附加信息
-(RACSignal *)saveThridAdditionInfoUserId:(NSString*)userId tokenId:(NSString*)tokenId ResumeId:(NSString*)ResumeId AdditionInfo:(NSString*)AdditionInfo
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeAdditionInfo" parameters:@{@"userId":userId,@"ResumeId":ResumeId,@"tokenId":tokenId,@"AdditionInfo":AdditionInfo}];
}
//删除附加信息
-(RACSignal *)deleteThridAdditionInfoUserId:(NSString*)userId tokenId:(NSString*)tokenId ResumeId:(NSString*)ResumeId additionID:(NSString*)additionID
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/DeleteResumeAttachmentFile" parameters:@{@"userId":userId,@"ResumeId":ResumeId,@"tokenId":tokenId,@"RaId":additionID}];
}
//保存自我评价
-(RACSignal *)saveThridAdditionInfoUserId:(NSString*)userId tokenId:(NSString*)tokenId ResumeId:(NSString*)ResumeId UserRemark:(NSString*)UserRemark;
{
      return [self.httpManager rac_POST:@"ThridEdition/Resume/SaveResumeUserRemark" parameters:@{@"userId":userId,@"ResumeId":ResumeId,@"tokenId":tokenId,@"UserRemark":UserRemark}];
}
// 编辑简历名称
-(RACSignal *)editBaseInfoRessumeWithUserID:(NSString*)userId tokenId:(NSString*)tokenId resumeID:(NSString *)resumeID resumeName:(NSString *)resumeName
{
    return [self.httpManager rac_POST:@"ThridEdition/Resume/UpdateResumeName" parameters:@{@"userId":userId, @"ResumeId":resumeID, @"tokenId":tokenId, @"ResumeName":resumeName}];
}
@end