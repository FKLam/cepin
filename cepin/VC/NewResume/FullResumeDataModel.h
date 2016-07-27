//
//  FullResumeDataModel.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@protocol ExperienceListDataModel
@end
@protocol SkillListDataModel
@end
@protocol HonourListDataModel
@end
@protocol EducationListDataModel
@end
@protocol LanguageListDataModel
@end
@protocol PracticalListDataModel
@end
@protocol TrainingListDataModel
@end
@protocol ProjectDataModel
@end
@protocol CertificateDataModel
@end
@protocol StudentLeadersListDataModel
@end


@interface ExperienceListDataModel : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *ExperienceId;//	String	经历ID
@property(nonatomic,strong)NSString<Optional> *ExperienceCompanyName;//	String	经历-公司名称
@property(nonatomic,strong)NSString<Optional> *CompanyInDB;//	String	返回公司ID
@property(nonatomic,strong)NSString<Optional> *ExperiencePostName;//	String	经历-职位名称
@property(nonatomic,strong)NSString<Optional> *ExperienceBeginTime;//	String	经历-开始时间
@property(nonatomic,strong)NSString<Optional> *ExperienceEndTime;//	String	经历-结束时间
@property(nonatomic,strong)NSString<Optional> *ExperienceDescription;//	String	经历-描述
@property(nonatomic,strong)NSNumber<Optional> *ExperiencePostKey;//	String	经历-描述
@end

@interface CertificateDataModel : BaseBeanModel
//专业证书
@property(nonatomic,strong)NSString<Optional> *Id;//	String
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String
@property(nonatomic,strong)NSString<Optional> *Date;//	String
@property(nonatomic,strong)NSString<Optional> *DateFormat;//	String
@property(nonatomic,strong)NSString<Optional> *Name;//	String
@property(nonatomic,strong)NSString<Optional> *ExpirationDate;//	String
@property(nonatomic,strong)NSString<Optional> *ExpirationDateFormat;//	String
@property(nonatomic,strong)NSString<Optional> *Content;//	String
@property(nonatomic,strong)NSNumber<Optional> *BaseCodeKey;//	String
@property(nonatomic,strong)NSNumber<Optional> *Type;//	String
+ (instancetype)beanFormDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

@interface SkillListDataModel : BaseBeanModel
//专业技能
@property(nonatomic,strong)NSString<Optional> *SkillId;//	String	技能ID
@property(nonatomic,strong)NSString<Optional> *SkillName;//	String	技能名称
@property(nonatomic,strong)NSString<Optional> *SkillExp;//	String	技能熟练度
@property(nonatomic,strong)NSString<Optional> *SkillTime;//	String	技能时间
@property(nonatomic,strong)NSString<Optional> *SkillDescription;//	String	技能描述
+ (instancetype)beanFormDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end


@interface HonourListDataModel : BaseBeanModel
//荣誉
@property(nonatomic,strong)NSString<Optional> *HonourId;//	String	荣誉ID
@property(nonatomic,strong)NSString<Optional> *HonourName;//	String	荣誉名称
@property(nonatomic,strong)NSString<Optional> *HonourTime;//	String	荣誉获得时间
@property(nonatomic,strong)NSString<Optional> *HonourDescription;//	String	荣誉描述（保留字段）

@end

//教育
@interface EducationListDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	教育ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String	对应简历id
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	(不用)
@property(nonatomic,strong)NSString<Optional> *StartDateFormat;//	String	教育开始时间
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	教育结束时间
@property(nonatomic,strong)NSString<Optional> *EndDateFormat;//	String	教育结束时间
@property(nonatomic,strong)NSString<Optional> *School;//	String	学校
@property(nonatomic,strong)NSString<Optional> *SchoolCode;//	String	学校code
@property(nonatomic,strong)NSString<Optional> *Major;//	String	专业
@property(nonatomic,strong)NSNumber<Optional> *MajorKey;//	String	专业key
@property(nonatomic,strong)NSString<Optional> *Degree;//	String	学历
@property(nonatomic,strong)NSNumber<Optional> *DegreeKey;//	String	学历key
@property(nonatomic,strong)NSString<Optional> *Description;//	String	专业说明
@property(nonatomic,strong)NSString<Optional> *Content;//	String     内容
@property(nonatomic,strong)NSNumber<Optional> *IsAbrot;//	String  海外经历
@property(nonatomic,strong)NSString<Optional> *SchoolLevel;//	String 学校等级

//+(FullResumeModel*)CreateWithEducation:(EducationListDataModel*)model;
+ (instancetype)beanFormDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end

@interface StudentLeadersListDataModel : BaseBeanModel
//学生干部
@property(nonatomic,strong)NSString<Optional> *Id;//	String	教育ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String	对应简历id
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	(不用)
@property(nonatomic,strong)NSString<Optional> *StartDateFormat;//	String	开始时间
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	结束时间
@property(nonatomic,strong)NSString<Optional> *EndDateFormat;//	String	结束时间
@property(nonatomic,strong)NSString<Optional> *ScoreDegree;//	String	学历
@property(nonatomic,strong)NSNumber<Optional> *ScoreDegreeKey;//	String	学历key
@property(nonatomic,strong)NSString<Optional> *Description;//	String	描述
@property(nonatomic,strong)NSString<Optional> *ScoreRanking;//	String
@property(nonatomic,strong)NSNumber<Optional> *Type;//	String
@property(nonatomic,strong)NSString<Optional> *ScoreGPA;//	String
@property(nonatomic,strong)NSString<Optional> *Name;//	String
@property(nonatomic,strong)NSString<Optional> *Level;//	String
//+(FullResumeModel*)CreateWithEducation:(EducationListDataModel*)model;
+ (instancetype)beanFormDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

@interface LanguageListDataModel : BaseBeanModel
//语言
@property(nonatomic,strong)NSString<Optional> *Id;//	String 语言id
@property(nonatomic,strong)NSString<Optional> *Name;//	String 名字
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String 简历id
@property(nonatomic,strong)NSString<Optional> *BaseCodeKey;//	String
@property(nonatomic,strong)NSString<Optional> *MasteryLevel;//	String
@property(nonatomic,strong)NSString<Optional> *Writing;//	String
@property(nonatomic,strong)NSString<Optional> *Speaking;//	String

+ (instancetype)beanFormDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

@interface PracticalListDataModel : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *Id;//	String	经历ID
@property(nonatomic,strong)NSString<Optional> *Name;//	String
@property(nonatomic,strong)NSString<Optional> *StartTime;//	String
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String
@property(nonatomic,strong)NSString<Optional> *StartDateFormat;//	String
@property(nonatomic,strong)NSString<Optional> *EndDateFormat;//	String
@property(nonatomic,strong)NSString<Optional> *Title;//	String
@property(nonatomic,strong)NSString<Optional> *Description;//	String
@property(nonatomic,strong)NSString<Optional> *Content;//	String

//+ (instancetype)beanFormDic:(NSDictionary *)dic;
//- (instancetype)initWithDic:(NSDictionary *)dic;

@end

@interface TrainingListDataModel : BaseBeanModel
//培训
@property(nonatomic,strong)NSString<Optional> *Id;//	String
@property(nonatomic,strong)NSString<Optional> *Name;//	String
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String
@property(nonatomic,strong)NSString<Optional> *EndDateFormat;//	String
@property(nonatomic,strong)NSString<Optional> *StartDateFormat;//	String
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String
@property(nonatomic,strong)NSString<Optional> *Organization;//	String
@property(nonatomic,strong)NSString<Optional> *Description;//	String
@property(nonatomic,strong)NSString<Optional> *Content;//	String
+ (instancetype)beanFormDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

@interface ProjectDataModel : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *Id;//	String
@property(nonatomic,strong)NSString<Optional> *Name;//	String
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String
@property(nonatomic,strong)NSString<Optional> *StartDateFormat;//	String
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String
@property(nonatomic,strong)NSString<Optional> *EndDateFormat;//	String
@property(nonatomic,strong)NSString<Optional> *KeyanLevel;//	String
@property(nonatomic,strong)NSString<Optional> *Description;//	String
@property(nonatomic,strong)NSString<Optional> *Content;//	String
@property(nonatomic,strong)NSString<Optional> *Duty;//	String
@property(nonatomic,strong)NSString<Optional> *KeyanGroup;//	String
@property(nonatomic,assign)BOOL IsKeyuan;//	String
+ (instancetype)beanFormDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

@interface FullResumeDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String	简历编号
@property(nonatomic,strong)NSString<Optional> *ResumeName;//	String	简历名称
@property(nonatomic,strong)NSString<Optional> *ChineseName;//	String	姓名
@property(nonatomic,strong)NSString<Optional> *PhotoUrlPath;//	String  头像
@property(nonatomic,strong)NSNumber<Optional> *Gender;//	Int	性别（0 未知1：男 ，2：女）
@property(nonatomic,strong)NSNumber<Optional> *Status;//	Int	置顶（1：置顶  0：非置顶）
@property(nonatomic,strong)NSNumber<Optional> *HR;//	Int	仅HR可见（1：是  0：否）
@property(nonatomic,strong)NSString<Optional> *Viewed;//	String	查看数
@property(nonatomic,strong)NSString<Optional> *Function;//	String	期望职位
@property(nonatomic,strong)NSMutableArray<Optional> *FunctionList;//	String	期望职位
@property(nonatomic,strong)NSString<Optional> *City;//	String	期望工作地点
@property(nonatomic,strong)NSMutableArray<Optional>*CityList;//如果citylist有值，则取citylist  如果citylist 没值则取city ，其中如果city要手动','分割
@property(nonatomic,strong)NSString<Optional> *Mobile;//	String	联系手机
@property(nonatomic,strong)NSString<Optional> *Email;//	String	联系邮箱
@property(nonatomic,strong)NSString<Optional> *DegreeId;//	String	学历ID
@property(nonatomic,strong)NSString<Optional> *Degree;//	String	学历
@property(nonatomic,strong)NSString<Optional> *SchoolId;//	String	学校ID
@property(nonatomic,strong)NSString<Optional> *School;//	String	学校名称
@property(nonatomic,strong)NSString<Optional> *MajorId;//	String	专业ID
@property(nonatomic,strong)NSString<Optional> *Major;//	String	专业
@property(nonatomic,strong)NSString<Optional> *GraduateDate;//	String	毕业时间
@property(nonatomic,strong)NSString<Optional> *CreatDate;//	String	创建时间
@property(nonatomic,strong)NSString<Optional> *RevisedDate;//	String	修改时间
@property(nonatomic,strong)NSNumber<Optional> *Age;//	String	年龄
@property(nonatomic,strong)NSString<Optional> *WorkYear;//	String	工作年限
@property(nonatomic,strong)NSString<Optional> *JobStatus;//	String	工作状态
@property(nonatomic,strong)NSString<Optional> *Address;//	String	联系地址
@property(nonatomic,strong)NSString<Optional> *PoliticsStatus;//	String	政治面貌
@property(nonatomic,strong)NSNumber<Optional> *IsMarriage;//	String	婚姻状况
@property(nonatomic,strong)NSString<Optional> *CensusRegister;//	String	户口所在地
@property(nonatomic,strong)NSString<Optional> *ExpectEmployType;//	String	期望工作类型
@property(nonatomic,strong)NSNumber<Optional> *ExpectSalary;//	String	期望薪酬
@property(nonatomic,strong)NSString<Optional> *UserReamrk;//	String	自我描述
@property(nonatomic,strong)NSString<Optional> *AdditionInfo;//	String	附加信息
@property(nonatomic,strong)NSString<Optional> *BarcodeContent;//	String
@property(nonatomic,strong)NSString<Optional> *BarcodeUrl;//	String 二维码
@property(nonatomic,strong)NSMutableArray<StudentLeadersListDataModel> *StudentLeadersList;// 学生干部
@property(nonatomic,strong)NSMutableArray<ExperienceListDataModel> *ExperienceList;//	List	经历列表
@property(nonatomic,strong)NSMutableArray<SkillListDataModel> *SkillList;//	List	专业技能
@property(nonatomic,strong)NSMutableArray<HonourListDataModel> *HonourList;//	List	荣誉列表
@property(nonatomic,strong)NSMutableArray<EducationListDataModel> *EducationExpList;//	List	教育列表
@property(nonatomic,strong)NSMutableArray<LanguageListDataModel> *LanguageList;//	List	语言列表
@property(nonatomic,strong)NSMutableArray<PracticalListDataModel> *PracticalExpList;//	List	实践列表
@property(nonatomic,strong)NSMutableArray<TrainingListDataModel> *TrainingExpList;//	List	培训列表
@property(nonatomic,strong)NSMutableArray<ProjectDataModel> *ProjectExpList;//	List	项目列表
@property(nonatomic,strong)NSMutableArray<CertificateDataModel> *Certificate;//	List	专业证书


+ (instancetype)beanFormDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
