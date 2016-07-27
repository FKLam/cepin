//
//  RTNetworking+Resume.h
//  cepin
//
//  Created by peng on 14-11-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTNetworking.h"

@interface RTNetworking (Resume)

/**
 * 3.5微简历接口
 
 3.5.1获得所有微简历接口 简历列表
 URL
 http://app2.cepin.com/Resume/List
 HTTP请求方式
 Get
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)getResumeListWithTokenId:(NSString *)tokenId userId:(NSString *)userId ResumeType:(NSString*)ResumeType;

/**
 *
 3.5.2添加微简历接口 添加微简历
 URL
 http://app2.cepin.com/Resume/Add
 HTTP请求方式
 Post
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)addResumeWithTokenId:(NSString *)tokenId userId:(NSString *)userId ResumeName:(NSString *)ResumeName ChineseName:(NSString *)ChineseName School:(NSString *)School SchoolId:(NSString *)SchoolId Major:(NSString *)Major MajorKey:(NSString *)MajorKey GraduateDate:(NSString *)GraduateDate Gender:(NSString *)Gender UserRemark:(NSString *)UserRemark Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey;


/**
 3.5.3修改微简历接口 修改微简历
 URL
 http://app2.cepin.com/Resume/Update
 HTTP请求方式
 Post
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)updateResumeWithTokenId:(NSString *)tokenId userId:(NSString *)userId ResumeId:(NSString *)ResumeId ResumeName:(NSString *)ResumeName ChineseName:(NSString *)ChineseName School:(NSString *)School SchoolId:(NSString *)SchoolId Major:(NSString *)Major MajorKey:(NSString *)MajorKey GraduateDate:(NSString *)GraduateDate Gender:(NSString *)Gender UserRemark:(NSString *)UserRemark Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey;



/**
 * 3.9 投递简历
 
 3.9.1 投递简历接口
 URL
 http://app2.cepin.com/ Resume / Delivery
 HTTP请求方式
 Get
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)resumeDeliveryWithUserId:(NSString *)userId tokenId:(NSString *)tokenId positionId:(NSString *)positionId resumeId:(NSString *)resumeId;

/**
 *
 3.9.2 投递简历列表接口
 URL
 http://app2.cepin.com/ Resume / DeliveriedList
 HTTP请求方式
 Get
 请求Headers
 无
 请求参数
 
 */

-(RACSignal *)getResumeDeliveriedListWithTokenId:(NSString *)tokenId userId:(NSString *)userId PageIndex:(NSInteger)PageIndex PageSize:(NSInteger)PageSize;


/**
 *
 3.9.3 简历置顶接口
 */

-(RACSignal *)toTopWithResumeId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId;

-(RACSignal *)deleteWithResumeId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId;
/**
 *复制简历接口
 *
 */
-(RACSignal *)copyWithResumeId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId;

-(RACSignal *)getResumeDetailWithResumeId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId;


-(RACSignal *)addRessume:(NSDictionary*)postDic;
-(RACSignal *)editRessume:(NSDictionary*)postDic;

-(RACSignal *)addAward:(NSDictionary*)postDic;

-(RACSignal *)editAward:(NSDictionary*)postDic;

-(RACSignal *)addSkill:(NSDictionary*)postDic;

-(RACSignal *)editSkill:(NSDictionary*)postDic;

-(RACSignal *)addExp:(NSDictionary*)postDic;

-(RACSignal *)editExp:(NSDictionary*)postDic;

-(RACSignal *)deleteExp:(NSString *)tokenId userId:(NSString *)userId ResumeId:(NSString*)ResumeId ExperienceId:(NSString*)ExperienceId;

-(RACSignal *)deleteSkill:(NSString *)tokenId userId:(NSString *)userId ResumeId:(NSString*)ResumeId SkillId:(NSString*)SkillId;

-(RACSignal *)deleteAward:(NSString *)tokenId userId:(NSString *)userId ResumeId:(NSString*)ResumeId HonourId:(NSString*)HonourId;

-(RACSignal *)getResumePreviewWithTokenId:(NSString *)tokenId userId:(NSString *)userId resumeId:(NSString*)resumeId;

//编辑社招基本信息
-(RACSignal *)addThridRessumeWith:(NSString*)ResumeName ChineseName:(NSString*)ChineseName Gender:(NSString*)Gender Email:(NSString*)Email Mobile:(NSString*)Mobile Birthday:(NSString*)Birthday Region:(NSString*)Region WorkYear:(NSString*)WorkYear IsSendCustomer:(NSString*)IsSendCustomer RegionCode:(NSString*)RegionCode WorkYearKey:(NSString*)WorkYearKey ResumeId:(NSString*)ResumeId userId:(NSString *)userId tokenId:(NSString *)tokenId JobStatus:(NSString*)JobStatus Politics:(NSString*)Politics PoliticsKey:(NSString*)PoliticsKey Hukou:(NSString*)Hukou HukouKey:(NSString*)HukouKey IdCardNumber:(NSString*)IdCardNumber GraduateDate:(NSString*)GraduateDate Address:(NSString*)Address Marital:(NSString*)Marital Introduces:(NSString *)Introduces;

//编辑校招基本信息
-(RACSignal *)addThridRessumeWith:(NSString*)ResumeName ChineseName:(NSString*)ChineseName Gender:(NSString*)Gender Email:(NSString*)Email Mobile:(NSString*)Mobile Birthday:(NSString*)Birthday Region:(NSString*)Region WorkYear:(NSString*)WorkYear IsSendCustomer:(NSString*)IsSendCustomer RegionCode:(NSString*)RegionCode WorkYearKey:(NSString*)WorkYearKey ResumeId:(NSString*)ResumeId userId:(NSString *)userId tokenId:(NSString *)tokenId JobStatus:(NSString*)JobStatus Politics:(NSString*)Politics PoliticsKey:(NSString*)PoliticsKey Hukou:(NSString*)Hukou HukouKey:(NSString*)HukouKey IdCardNumber:(NSString*)IdCardNumber GraduateDate:(NSString*)GraduateDate Address:(NSString*)Address Marital:(NSString*)Marital QQ:(NSString*)QQ Nation:(NSString*)Nation Weight:(NSString*)Weight HealthType:(NSString*)HealthType Height:(NSString*)Height  NativeCity:(NSString*)NativeCity NativeCityKey:(NSString*)NativeCityKey EmergencyContact:(NSString*)EmergencyContact EmergencyContactPhone:(NSString*)EmergencyContactPhone ZipCode:(NSString*)ZipCode Health:(NSString*)Health;

//编辑基本信息简历引导
-(RACSignal *)addThridRessumeWith:(NSString*)ResumeName ChineseName:(NSString*)ChineseName Gender:(NSString*)Gender Email:(NSString*)Email Mobile:(NSString*)Mobile Birthday:(NSString*)Birthday Region:(NSString*)Region WorkYear:(NSString*)WorkYear IsSendCustomer:(NSString*)IsSendCustomer RegionCode:(NSString*)RegionCode WorkYearKey:(NSString*)WorkYearKey ResumeId:(NSString*)ResumeId userId:(NSString *)userId tokenId:(NSString *)tokenId JobStatus:(NSString*)JobStatus ResumeType:(NSString*)resumeType Introduces:(NSString *)Introduces idCardNumber:(NSString *)idCardNumber;

//3.1创建校招简历基本信息
-(RACSignal *)addThridRessumeWithSchoolResume:(NSString*)ResumeName ChineseName:(NSString*)ChineseName Gender:(NSString*)Gender Email:(NSString*)Email Mobile:(NSString*)Mobile Birthday:(NSString*)Birthday Region:(NSString*)Region WorkYear:(NSString*)WorkYear IsSendCustomer:(NSString*)IsSendCustomer RegionCode:(NSString*)RegionCode WorkYearKey:(NSString*)WorkYearKey ResumeId:(NSString*)ResumeId userId:(NSString *)userId tokenId:(NSString *)tokenId JobStatus:(NSString*)JobStatus ResumeType:(NSString*)resumeType Weight:(NSString*)Weight HealthType:(NSString*)HealthType Height:(NSString*)Height Nation:(NSString*)Nation NativeCity:(NSString*)NativeCity GraduateDate:(NSString*)GraduateDate Politics:(NSString*)Politics NativeCityKey:(NSString*)NativeCityKey PoliticsKey:(NSString*)PoliticsKey Health:(NSString*)Health idCardNumber:(NSString *)idCardNumber;


//添加简历3.0
-(RACSignal *)addThridRessume:(NSString*)userId tokenId:(NSString*)tokenId;
//编辑基本信息
-(RACSignal *)addThridRessume:(NSDictionary*)postDic;
//获取信息
-(RACSignal *)getThridResumeDetailWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//添加简历关键字
-(RACSignal *)addThridResumeKeyWordWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString *)tokenId keyWords:(NSString*)keyWords;


//添加期望工作
-(RACSignal *)saveThridExpectJobWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId ExpectCity:(NSString*)ExpectCity ExpectIndustry:(NSString*)ExpectIndustry ExpectEmployType:(NSString*)ExpectEmployType ExpectSalary:(NSString*)ExpectSalary;

//3.1添加校招期望工作
-(RACSignal *)saveThridExpectJobWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId ExpectCity:(NSString*)ExpectCity ExpectIndustry:(NSString*)ExpectIndustry ExpectEmployType:(NSString*)ExpectEmployType ExpectSalary:(NSString*)ExpectSalary AvailableType:(NSString*)AvailableType IsAllowDistribution:(NSString*)IsAllowDistribution;

//工作状态
-(RACSignal *)addThridResumeJobStatusWithUserId:(NSString *)userId tokenId:(NSString *)tokenId workStatusCode:(NSString*)workStatusCode;

//工作列表获取
-(RACSignal *)getThridResumeWorkListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//删除工作经历
-(RACSignal *)deleteThridResumeWorkListWithResumeId:(NSString *)resumeId workId:(NSString*)workId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//获取工作信息
-(RACSignal *)getThridResumeWorkListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;

//保存工作经历
-(RACSignal *)saveThridWorkStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Nature:(NSString*)Nature Size:(NSString*)Size Industry:(NSString*)Industry JobCity:(NSString*)JobCity JobFunction:(NSString*)JobFunction Content:(NSString*)Content Salary:(NSString*)Salary CompanyRanking:(NSString*)CompanyRanking ResumeId:(NSString*)ResumeId Id:(NSString*)Id NatureKey:(NSString*)NatureKey IndustryKey:(NSString*)IndustryKey JobCityKey:(NSString*)JobCityKey JobFunctionKey:(NSString*)JobFunctionKey SizeKey:(NSString*)SizeKey Company:(NSString*)Company IsAbroad:(NSString*)IsAbroad;

//3.1保存校招工作经历
-(RACSignal *)saveThridWorkStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Nature:(NSString*)Nature Size:(NSString*)Size Industry:(NSString*)Industry JobCity:(NSString*)JobCity JobFunction:(NSString*)JobFunction Content:(NSString*)Content Salary:(NSString*)Salary CompanyRanking:(NSString*)CompanyRanking ResumeId:(NSString*)ResumeId Id:(NSString*)Id NatureKey:(NSString*)NatureKey IndustryKey:(NSString*)IndustryKey JobCityKey:(NSString*)JobCityKey JobFunctionKey:(NSString*)JobFunctionKey SizeKey:(NSString*)SizeKey Company:(NSString*)Company IsAbroad:(NSString*)IsAbroad AttestorName:(NSString*)AttestorName AttestorRelation:(NSString*)AttestorRelation AttestorPosition:(NSString*)AttestorPosition AttestorCompany:(NSString*)AttestorCompany AttestorPhone:(NSString*)AttestorPhone;

//添加
-(RACSignal *)saveThridWorkStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Nature:(NSString*)Nature Size:(NSString*)Size Industry:(NSString*)Industry JobCity:(NSString*)JobCity JobFunction:(NSString*)JobFunction Content:(NSString*)Content Salary:(NSString*)Salary CompanyRanking:(NSString*)CompanyRanking ResumeId:(NSString*)ResumeId NatureKey:(NSString*)NatureKey IndustryKey:(NSString*)IndustryKey JobCityKey:(NSString*)JobCityKey JobFunctionKey:(NSString*)JobFunctionKey SizeKey:(NSString*)SizeKey Company:(NSString*)Company IsAbroad:(NSString*)IsAbroad;

//3.1添加实习经历
-(RACSignal *)saveThridWorkStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Nature:(NSString*)Nature Size:(NSString*)Size Industry:(NSString*)Industry JobCity:(NSString*)JobCity JobFunction:(NSString*)JobFunction Content:(NSString*)Content Salary:(NSString*)Salary CompanyRanking:(NSString*)CompanyRanking ResumeId:(NSString*)ResumeId NatureKey:(NSString*)NatureKey IndustryKey:(NSString*)IndustryKey JobCityKey:(NSString*)JobCityKey JobFunctionKey:(NSString*)JobFunctionKey SizeKey:(NSString*)SizeKey Company:(NSString*)Company IsAbroad:(NSString*)IsAbroad AttestorName:(NSString*)AttestorName AttestorRelation:(NSString*)AttestorRelation AttestorPosition:(NSString*)AttestorPosition AttestorCompany:(NSString*)AttestorCompany AttestorPhone:(NSString*)AttestorPhone;


//教育列表获取
-(RACSignal *)getThridResumeEducationListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//删除教育列表
-(RACSignal *)deleteThridResumeEducationListWithResumeId:(NSString *)resumeId eduId:(NSString*)eduId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//获取教育信息
-(RACSignal *)getThridResumeEducationListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;

//保存教育
-(RACSignal *)saveThridEducationStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate SchoolCode:(NSString*)SchoolCode School:(NSString*)School Major:(NSString*)Major MajorKey:(NSString*)MajorKey Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey ResumeId:(NSString*)ResumeId Id:(NSString*)Id;

//3.1保存校招教育
-(RACSignal *)saveThridEducationStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate SchoolCode:(NSString*)SchoolCode School:(NSString*)School Major:(NSString*)Major MajorKey:(NSString*)MajorKey Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey ResumeId:(NSString*)ResumeId Id:(NSString*)Id ScoreRanking:(NSString*)ScoreRanking Xuewei:(NSString*)Xuewei Description:(NSString*)Description;

//添加教育
-(RACSignal *)addThridEducationStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate SchoolCode:(NSString*)SchoolCode School:(NSString*)School Major:(NSString*)Major MajorKey:(NSString*)MajorKey Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey ResumeId:(NSString*)ResumeId;

//3.1添加校招教育
-(RACSignal *)addThridEducationStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate SchoolCode:(NSString*)SchoolCode School:(NSString*)School Major:(NSString*)Major MajorKey:(NSString*)MajorKey Degree:(NSString*)Degree DegreeKey:(NSString*)DegreeKey ResumeId:(NSString*)ResumeId ScoreRanking:(NSString*)ScoreRanking Xuewei:(NSString*)Xuewei Description:(NSString*)Description;

//项目列表
-(RACSignal *)getThridResumeProjectListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//删除项目列表
-(RACSignal *)deleteThridResumeProjectListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;

//获取项目信息
-(RACSignal *)getThridResumeProjectListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;

//保存项目
-(RACSignal *)saveThridProjectStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Duty:(NSString*)Duty Name:(NSString*)Name KeyanLevel:(NSString*)KeyanLevel Description:(NSString*)Description Content:(NSString*)Content ResumeId:(NSString*)ResumeId Id:(NSString*)Id ProjectLink:(NSString *)ProjectLink IsKeyuan:(NSString *)IsKeyuan;

//添加项目
-(RACSignal *)addThridProjectStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Duty:(NSString*)Duty Name:(NSString*)Name KeyanLevel:(NSString*)KeyanLevel Description:(NSString*)Description Content:(NSString*)Content ResumeId:(NSString*)ResumeId ProjectLink:(NSString *)ProjectLink IsKeyuan:(NSString *)IsKeyuan;

//专业列表
-(RACSignal *)getThridResumeCredentialListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//删除专业
-(RACSignal *)deleteThridResumeCredentialListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;

//保存专业
-(RACSignal *)saveThridCredentialDate:(NSString*)Date userId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name BaseCodeKey:(NSString*)BaseCodeKey ResumeId:(NSString*)ResumeId Id:(NSString*)Id Type:(NSString*)Type;

//添加专业
-(RACSignal *)addThridCredentialDate:(NSString*)Date userId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name BaseCodeKey:(NSString*)BaseCodeKey ResumeId:(NSString*)ResumeId Type:(NSString*)Type;

//技能列表
-(RACSignal *)getThridResumeSkillListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//保存专业技能
-(RACSignal *)saveThridSkillUserId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name MasteryLevel:(NSString*)MasteryLevel ResumeId:(NSString*)ResumeId Id:(NSString*)Id;

//添加专业技能
-(RACSignal *)addThridSkillUserId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name MasteryLevel:(NSString*)MasteryLevel ResumeId:(NSString*)ResumeId;

//删除技能
-(RACSignal *)deleteThridResumeSkillListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;

//语言列表
-(RACSignal *)getThridResumeLanguageListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//保存语言
-(RACSignal *)saveThridLanguageUserId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name BaseCodeKey:(NSString*)BaseCodeKey ResumeId:(NSString*)ResumeId Id:(NSString*)Id Writing:(NSString*)Writing Speaking:(NSString*)Speaking;

//3.1编辑英语等级
-(RACSignal *)saveThridEnglishUserId:(NSString*)userId tokenId:(NSString*)tokenId ResumeId:(NSString*)ResumeId IsHasCET4Score:(NSString*)IsHasCET4Score IsHasCET6Score:(NSString*)IsHasCET6Score IsHasTEM4Score:(NSString*)IsHasTEM4Score IsHasTEM8Score:(NSString*)IsHasTEM8Score IsHasIELTSScore:(NSString*)IsHasIELTSScore IsHasTOEFLScore:(NSString*)IsHasTOEFLScore CET4Score:(NSString*)CET4Score CET6Score:(NSString*)CET6Score TEM4Score:(NSString*)TEM4Score TEM8Score:(NSString*)TEM8Score TOEFLScore:(NSString*)TOEFLScore IELTSScore:(NSString*)IELTSScore;

//添加语言
-(RACSignal *)addThridLanguageUserId:(NSString*)userId tokenId:(NSString*)tokenId Name:(NSString*)Name BaseCodeKey:(NSString*)BaseCodeKey ResumeId:(NSString*)ResumeId Writing:(NSString*)Writing Speaking:(NSString*)Speaking;

//删除语言
-(RACSignal *)deleteThridResumeLanguageListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;

//实践经历列表
-(RACSignal *)getThridResumePracticeListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId;

//添加实践经历
-(RACSignal *)addThridPracticeStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Title:(NSString*)Title Name:(NSString*)Name Content:(NSString*)Content ResumeId:(NSString*)ResumeId;

//保存实践经历
-(RACSignal *)saveThridPracticeStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Title:(NSString*)Title Name:(NSString*)Name Content:(NSString*)Content ResumeId:(NSString*)ResumeId Id:(NSString*)Id;

//删除实践经历
-(RACSignal *)deleteThridResumePracticeListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;

//获取奖励列表 
-(RACSignal *)getThridResumeAwardListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId type:(NSString*)type;

//删除奖励列表
-(RACSignal *)deleteThridResumeAwardListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;


//保存奖励
-(RACSignal *)saveThridAwardStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId Level:(NSString*)Level Name:(NSString*)Name ResumeId:(NSString*)ResumeId Id:(NSString*)Id type:(NSString*)type;
//添加奖励
-(RACSignal *)addThridAwardStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId Level:(NSString*)Level Name:(NSString*)Name ResumeId:(NSString*)ResumeId type:(NSString*)type;

//保存学生干部
-(RACSignal *)saveThridStudentStartDate:(NSString*)StartDate EndDate:(NSString*)EndDate userId:(NSString*)userId tokenId:(NSString*)tokenId Level:(NSString*)Level Name:(NSString*)Name ResumeId:(NSString*)ResumeId Id:(NSString*)Id type:(NSString*)type;
//添加学生干部
-(RACSignal *)addThridStudentStartDate:(NSString*)StartDate EndDate:(NSString*)EndDate userId:(NSString*)userId tokenId:(NSString*)tokenId Level:(NSString*)Level Name:(NSString*)Name ResumeId:(NSString*)ResumeId type:(NSString*)type;
//培训列表
-(RACSignal *)getThridResumeTrainListWithResumeId:(NSString *)resumeId userId:(NSString *)userId tokenId:(NSString*)tokenId;
//删除培训
-(RACSignal *)deleteThridResumeTrainListWithResumeId:(NSString *)resumeId Id:(NSString*)Id userId:(NSString *)userId tokenId:(NSString*)tokenId;
//保存培训
-(RACSignal *)saveThridTrainStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Organization:(NSString*)Organization Name:(NSString*)Name Content:(NSString*)Content ResumeId:(NSString*)ResumeId Id:(NSString*)Id;
//添加
-(RACSignal *)addThridTrainStartDate:(NSString*)StartDate userId:(NSString*)userId tokenId:(NSString*)tokenId EndDate:(NSString*)EndDate Organization:(NSString*)Organization Name:(NSString*)Name Content:(NSString*)Content ResumeId:(NSString*)ResumeId;

//保存附加信息
-(RACSignal *)saveThridAdditionInfoUserId:(NSString*)userId tokenId:(NSString*)tokenId ResumeId:(NSString*)ResumeId AdditionInfo:(NSString*)AdditionInfo;

//保存自我评价
-(RACSignal *)saveThridAdditionInfoUserId:(NSString*)userId tokenId:(NSString*)tokenId ResumeId:(NSString*)ResumeId UserRemark:(NSString*)UserRemark;
//删除附加信息
-(RACSignal *)deleteThridAdditionInfoUserId:(NSString*)userId tokenId:(NSString*)tokenId ResumeId:(NSString*)ResumeId additionID:(NSString*)additionID;
// 检验邮箱是否已绑定
- (RACSignal *)checkIsExistEmail:(NSString *)email tokenID:(NSString *)tokenID userID:(NSString *)userID;
// 触发发送绑定邮箱信息
- (RACSignal *)sendBindEmail:(NSString *)email tokenID:(NSString *)tokenID userID:(NSString *)userID;
// 编辑简历名称
-(RACSignal *)editBaseInfoRessumeWithUserID:(NSString*)userId tokenId:(NSString*)tokenId resumeID:(NSString *)resumeID resumeName:(NSString *)resumeName;
@end
