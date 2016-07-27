//
//  ResumeNameModel.h
//  cepin
//
//  Created by dujincai on 15/6/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@protocol PracticeListDataModel
@end

@protocol ComputerListDataModel
@end
@protocol CredentialListDataModel
@end
@protocol StudyAchievementListDataModel
@end

@protocol AwardsListDataModel
@end
@protocol StudentLeadersDataModel
@end

@protocol LanguageDataModel
@end

@protocol ProjectListDataModel
@end

@protocol WorkListDateModel
@end
@protocol EducationListDateModel
@end
@protocol SkillDataModel
@end
@protocol TrainingDataModel
@end

@protocol  AttachmentDataModel
@end

// 附加信息的附件
@interface AttachmentDataModel : BaseBeanModel
@property (nonatomic, strong) NSString<Optional> *ResumeId;
@property (nonatomic, strong) NSString<Optional> *Name;
@property (nonatomic, strong) NSString<Optional> *FilePath;
@property (nonatomic, strong) NSString<Optional> *AttachmentSize;
@property (nonatomic, strong) NSString<Optional> *Id;

@end

//实践经历
@interface PracticeListDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	开始时间
@property(nonatomic,strong)NSString<Optional> *Name ;//	String	实践名称
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	结束时间
@property(nonatomic,strong)NSString<Optional> *Content;//	String	实践内容
@property(nonatomic,strong)NSString<Optional> *Title ;//	String	职务
@property(nonatomic,strong)NSNumber<Optional> *Description;//职务说明

@end

//计算机等级证书
@interface ComputerListDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *Date;//	String	获得日期
@property(nonatomic,strong)NSString<Optional> *Name ;//	String	证书名称
@property(nonatomic,strong)NSString<Optional> *ExpirationDate;//	String	有效日期
@property(nonatomic,strong)NSString<Optional> *Content;//	String	内容
@property(nonatomic,strong)NSString<Optional> *BaseCodeKey ;//	String	计算机等级Key
@property(nonatomic,strong)NSNumber<Optional> *Type;//证书类型 1：计算机等级，2：证书等级
@end

//获得证书
@interface CredentialListDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *Date;//	String	获得日期
@property(nonatomic,strong)NSString<Optional> *Name ;//	String	证书名称
@property(nonatomic,strong)NSString<Optional> *ExpirationDate;//	String	有效日期
@property(nonatomic,strong)NSString<Optional> *Content;//	String	内容
@property(nonatomic,strong)NSString<Optional> *BaseCodeKey ;//	String	计算机等级Key
@property(nonatomic,strong)NSNumber<Optional> *Type;//证书类型 1：计算机等级，2：证书等级
@end

//学习成绩奖励
@interface StudyAchievementListDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	经历ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *Name ;//	String	名称
@property(nonatomic,strong)NSString<Optional> *Level;//	String  级别
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	经历-开始时间
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	经历-结束时间
@property(nonatomic,strong)NSNumber<Optional> *Type;//	String	学生经历类型   1：学生干部=校内职务，2：学习成绩奖励，3：非学习成绩奖励
@property(nonatomic,strong)NSString<Optional> *ScoreDegree;//	String	成绩学历
@property(nonatomic,strong)NSString<Optional> *ScoreGPA;//	String  成绩GPA
@property(nonatomic,strong)NSString<Optional> *ScoreRanking ;//	String	成绩排行
@property(nonatomic,strong)NSString<Optional> *Description ;//	String	说明
@end

//获得奖项
@interface AwardsListDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	经历ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *Name ;//	String	名称
@property(nonatomic,strong)NSString<Optional> *Level;//	String  级别
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	经历-开始时间
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	经历-结束时间
@property(nonatomic,strong)NSNumber<Optional> *Type;//	String	学生经历类型   1：学生干部=校内职务，2：学习成绩奖励，3：非学习成绩奖励
@property(nonatomic,strong)NSString<Optional> *ScoreDegree;//	String	成绩学历
@property(nonatomic,strong)NSString<Optional> *ScoreGPA;//	String  成绩GPA
@property(nonatomic,strong)NSString<Optional> *ScoreRanking ;//	String	成绩排行
@property(nonatomic,strong)NSString<Optional> *Description ;//	String	说明
@end

//项目经验
@interface ProjectListDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	经历ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *Duty ;//	String	职责
@property(nonatomic,strong)NSString<Optional> *Name ;//	String	项目名称
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	经历-开始时间
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	经历-结束时间
@property(nonatomic,strong)NSString<Optional> *KeyanLevel ;//	String	科研级别
@property(nonatomic,strong)NSString<Optional> *Description;//	String	项目说明
@property(nonatomic,strong)NSString<Optional> *Content;//	String	内容
@property(nonatomic,strong)NSString<Optional> *IsKeyuan ;//	String	是否科研
@property(nonatomic,strong)NSString<Optional> *KeyanGroup ;//	String	科研角色
@property (nonatomic, strong) NSString *ProjectLink; // 项目链接
@end

//工作经历
@interface WorkListDateModel : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *Id;//	String	经历ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *Company ;//	String	公司
@property(nonatomic,strong)NSString<Optional> *CompanyId;//	String	公司Id
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	经历-开始时间
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	经历-结束时间
@property(nonatomic,strong)NSString<Optional> *Nature;//	String	公司性质
@property(nonatomic,strong)NSString<Optional> *NatureKey;//	String	公司性质Key
@property(nonatomic,strong)NSString<Optional> *Size;//	String  公司规模
@property(nonatomic,strong)NSString<Optional> *SizeKey;//	String	公司规模Key
@property(nonatomic,strong)NSString<Optional> *Industry;//	String	行业
@property(nonatomic,strong)NSString<Optional> *IndustryKey;//	String	行业Key
@property(nonatomic,strong)NSString<Optional> *JobCity;//	String	工作地点
@property(nonatomic,strong)NSString<Optional> *JobCityKey ;//	String	工作地点Key
@property(nonatomic,strong)NSString<Optional> *JobFunction;//	String	工作职能
@property(nonatomic,strong)NSString<Optional> *JobFunctionKey;//	String  工作职能Key
@property(nonatomic,strong)NSString<Optional> *Department;//	String	部门
@property(nonatomic,strong)NSString<Optional> *Description;//	String	职责说明
@property(nonatomic,strong)NSString<Optional> *Content;//	String	内容
@property(nonatomic,strong)NSNumber<Optional> *IsAbroad ;//	String	海外经历
@property(nonatomic,strong)NSString<Optional> *CompanyRanking ;//	String	公司排名
@property(nonatomic,strong)NSString<Optional> *Salary ;//	String	薪水
//3.1新增
@property(nonatomic,strong)NSString<Optional> *AttestorName;//	String	证明人姓名
@property(nonatomic,strong)NSString<Optional> *AttestorRelation;//	String	证明人关系
@property(nonatomic,strong)NSString<Optional> *AttestorPosition ;//	String	证明人职务
@property(nonatomic,strong)NSString<Optional> *AttestorCompany ;//	String	证明人单位
@property(nonatomic,strong)NSString<Optional> *AttestorPhone ;//	String	证明人电话

@end


//教育经历
@interface EducationListDateModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	经历ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *SchoolCode ;//	String	学校Code
@property(nonatomic,strong)NSString<Optional> *School;//	String	学校
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	经历-开始时间
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	经历-结束时间
@property(nonatomic,strong)NSString<Optional> *Major;//	String	专业
@property(nonatomic,strong)NSString<Optional> *MajorKey;//	String	专业Code
@property(nonatomic,strong)NSString<Optional> *Degree;//	String  学历
@property(nonatomic,strong)NSString<Optional> *DegreeKey ;//	String	学历Key
@property(nonatomic,strong)NSString<Optional> *Description ;//	String	专业说明 主修课程
@property(nonatomic,strong)NSString<Optional> *Content ;//	String	内容
@property(nonatomic,strong)NSString<Optional> *IsAbroad;//	String	海外经历
@property(nonatomic,strong)NSString<Optional> *SchoolLevel;//	String	学校等级
//3.1新增
@property(nonatomic,strong)NSString<Optional> *XueWei;//	String	学位
@property(nonatomic,strong)NSString<Optional> *ScoreRanking;//	String	成绩排名

@end


//学生经历
@interface StudentLeadersDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	经历ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *Name ;//	String	名称
@property(nonatomic,strong)NSString<Optional> *Level;//	String  级别
@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	经历-开始时间
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	经历-结束时间
@property(nonatomic,strong)NSNumber<Optional> *Type;//	String	学生经历类型   1：学生干部=校内职务，2：学习成绩奖励，3：非学习成绩奖励
@property(nonatomic,strong)NSString<Optional> *ScoreDegree;//	String	成绩学历
@property(nonatomic,strong)NSString<Optional> *ScoreGPA;//	String  成绩GPA
@property(nonatomic,strong)NSString<Optional> *ScoreRanking ;//	String	成绩排行
@property(nonatomic,strong)NSString<Optional> *Description ;//	String	说明
@end
//语言
@interface LanguageDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String  简历Id
@property(nonatomic,strong)NSString<Optional> *BaseCodeKey;//	String	语言Key
@property(nonatomic,strong)NSString<Optional> *Name ;//	String	语言
@property(nonatomic,strong)NSString<Optional> *MasteryLevel;//	String	掌握程度
@property(nonatomic,strong)NSString<Optional> *Writing;//	String	读写能力
@property(nonatomic,strong)NSString<Optional> *Speaking ;//	String	听说能力
@end

//专业技能
@interface SkillDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	技能ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//简历Id
@property(nonatomic,strong)NSString<Optional> *Name;//	String	技能名称
@property(nonatomic,strong)NSString<Optional> *MasteryLevel ;//	String	掌握程度
@property(nonatomic,strong)NSNumber<Optional> *UsingTime;//	String	使用时间
@property(nonatomic,strong)NSString<Optional> *Description;//	String	技能描述
@property(nonatomic,strong)NSString<Optional> *StartTime;//开始使用时间
@property(nonatomic,strong)NSString<Optional> *Content ;//	String	培训内容
@property(nonatomic,strong)NSString<Optional> *StartDate; // 开始时间
@property(nonatomic,strong)NSString<Optional> *SkillBeginTime;
@end

//培训列表
@interface TrainingDataModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *Id;//	String	技能ID
@property(nonatomic,strong)NSString<Optional> *ResumeId;//简历Id
@property(nonatomic,strong)NSString<Optional> *Name;//	String	培训课程
@property(nonatomic,strong)NSString<Optional> *Organization ;//	String	培训机构
@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	结束时间
@property(nonatomic,strong)NSString<Optional> *Description;//	String	机构说明
@property(nonatomic,strong)NSString<Optional> *StartDate;//开始使用时间
@property(nonatomic,strong)NSString<Optional> *Content;//内容
@end

//基本信息
@interface ResumeNameModel : BaseBeanModel
@property(nonatomic,strong)NSNumber<Optional> *ViewCount; //
@property(nonatomic,strong)NSNumber<Optional> *UpFile; //
@property(nonatomic,strong)NSNumber<Optional> *MaritalName; //
@property(nonatomic,strong)NSNumber<Optional> *GenderName; //
@property(nonatomic,strong)NSNumber<Optional> *BEC; //
@property(nonatomic,strong)NSNumber<Optional> *IELTS; //
@property(nonatomic,strong)NSNumber<Optional> *TOEFL; //
@property(nonatomic,strong)NSNumber<Optional> *TOEIC; //
@property(nonatomic,strong)NSNumber<Optional> *Age;  //年龄
@property(nonatomic,strong)NSNumber<Optional> *ResumeScore; //简历分数
@property(nonatomic,strong)NSNumber<Optional> *ExpectSalaryMin; //意向月薪最小值
@property(nonatomic,strong)NSNumber<Optional> *ExpectSalaryMax; //意向月薪最大值
@property(nonatomic,strong)NSNumber<Optional> *IsMicroResume; //是否是微简历
@property(nonatomic,strong)NSNumber<Optional> *IsCompleteResume  ; //是否是完整简历
@property(nonatomic,strong)NSString<Optional> *IsSendCustomer ; //是否自动推送给企业
@property(nonatomic,strong)NSNumber<Optional> *IsCreateIndex ; //是否已生成索引
@property(nonatomic,strong)NSString<Optional> *AdditionInfo;//附加信息
@property(nonatomic,strong)NSString<Optional> *EnglishLevelKey;//英语级别key
@property(nonatomic,strong)NSString<Optional> *HighSchoolExamRegionCode ;//高考所在城市
@property(nonatomic,strong)NSString<Optional> *GraduateDate;//毕业年份
@property(nonatomic,strong)NSNumber<Optional> *IsScholarship ; //是否有奖学金
@property(nonatomic,strong)NSNumber<Optional> *IsFieldwork ; //是否有实习经历
@property(nonatomic,strong)NSNumber<Optional> *IsStudentLeaders ; //是否学生干部
@property(nonatomic,strong)NSString<Optional> *ExpectSalaryFloatRate;//期望年薪浮动比率
@property(nonatomic,strong)NSNumber<Optional> *Status; //状态（0：无效，1：有效，-1：删除
@property(nonatomic,strong)NSNumber<Optional> *OrderNuber; //排序
@property(nonatomic,strong)NSString<Optional> *RevisedDate;//简历更新时间
@property(nonatomic,strong)NSNumber<Optional> *IsPublic; //联系 方式是否公开
@property(nonatomic,strong)NSNumber<Optional> *CompleteRate;//简历完整度(0-100)
@property(nonatomic,strong)NSString<Optional> *Keywords;//简历关键字
@property(nonatomic,strong)NSNumber<Optional> *ResumeType;//（1：普通简历,2：应届生）简历类型(社招=1，校招=2)
@property(nonatomic,strong)NSString<Optional> *Remark;//备注
@property(nonatomic,strong)NSString<Optional> *CreateDate;//创建时间
@property(nonatomic,strong)NSString<Optional> *ResumeFile;//简历文件存档
@property(nonatomic,strong)NSString<Optional> *ResumeText;//简历原始文本
@property(nonatomic,strong)NSString<Optional> *SourceType;//简历来源
@property(nonatomic,strong)NSString<Optional> *CertificateJson;//
@property(nonatomic,strong)NSString<Optional> *CertificateText;//
@property(nonatomic,strong)NSString<Optional> *RewardJson;//
@property(nonatomic,strong)NSString<Optional> *RewardText;//
@property(nonatomic,strong)NSString<Optional> *PracticeJson ;//
@property(nonatomic,strong)NSString<Optional> *PracticeText;//
@property(nonatomic,strong)NSString<Optional> *TrainingJson ;//
@property(nonatomic,strong)NSString<Optional> *TrainningText;//
@property(nonatomic,strong)NSString<Optional> *SkillJson;//
@property(nonatomic,strong)NSString<Optional> *SkillText;//
@property(nonatomic,strong)NSString<Optional> *LanguageJson ;//
@property(nonatomic,strong)NSString<Optional> *LanguageText;//
@property(nonatomic,strong)NSString<Optional> *ProjectJson ;//
@property(nonatomic,strong)NSString<Optional> *ProjectText;//
@property(nonatomic,strong)NSString<Optional> *StudentExperienceJson;//
@property(nonatomic,strong)NSString<Optional> *StudentExperience;//
@property(nonatomic,strong)NSString<Optional> *EducationJson ;//教育经历列表
@property(nonatomic,strong)NSString<Optional> *EducationText;//教育经历
@property(nonatomic,strong)NSString<Optional> *JobJson ;//工作经验列表
@property(nonatomic,strong)NSString<Optional> *JobText;//工作经验
@property(nonatomic,strong)NSString<Optional> *EnglishLevel;//英语级别
@property(nonatomic,strong)NSString<Optional> *UserRemark;//自我描述
@property(nonatomic,strong)NSString<Optional> *AvailableType;//到职时间
@property(nonatomic,strong)NSString<Optional> *ExpectSalary;//期望薪资
@property(nonatomic,strong)NSString<Optional> *ExpectCity3;//意向城市3
@property(nonatomic,strong)NSString<Optional> *ExpectCity2;//意向城市2
@property(nonatomic,strong)NSString<Optional> *ExpectCity;//意向城市
@property(nonatomic,strong)NSString<Optional> *ExpectJobFunction3;//意向职能3
@property(nonatomic,strong)NSString<Optional> *ExpectJobFunction2 ;//意向职能2
@property(nonatomic,strong)NSString<Optional> *ExpectJobFunction;//意向职能
@property(nonatomic,strong)NSString<Optional> *ExpectIndustry3;//意向行业3
@property(nonatomic,strong)NSString<Optional> *ExpectIndustry2 ;//意向行业2
@property(nonatomic,strong)NSString<Optional> *ExpectIndustry;//意向行业
@property(nonatomic,strong)NSString<Optional> *ExpectEmployType ;//意向工作性质
@property(nonatomic,strong)NSString<Optional> *AnnualSalary;//当前年薪
@property(nonatomic,strong)NSString<Optional> *AnnualSalaryKey;//当前年薪key
@property(nonatomic,strong)NSString<Optional> *PositionName;//当前职位
@property(nonatomic,strong)NSString<Optional> *JobFunction;//当前职能
@property(nonatomic,strong)NSString<Optional> *JobTitleLevel;//职称级别
@property(nonatomic,strong)NSString<Optional> *JobTitle;//职称
@property(nonatomic,strong)NSString<Optional> *Company;//当前公司
@property(nonatomic,strong)NSString<Optional> *PhoneOffice;//工作电话
@property(nonatomic,strong)NSString<Optional> *CompanyId;//当前公司id
@property(nonatomic,strong)NSString<Optional> *JobFunctionKey;//当前职能key
@property(nonatomic,strong)NSString<Optional> *Industry;//当前行业
@property(nonatomic,strong)NSString<Optional> *IndustryKey;//当前行业key
@property(nonatomic,strong)NSString<Optional> *WorkYear;//工作年限
@property(nonatomic,strong)NSString<Optional> *WorkYearKey;//工作年限Key
@property(nonatomic,strong)NSString<Optional> *ZipCode;//邮政编码
@property(nonatomic,strong)NSString<Optional> *Address;//通讯地址
@property(nonatomic,strong)NSString<Optional> *PhoneHome;//家庭电话
@property(nonatomic,strong)NSString<Optional> *Region;//居住地
@property(nonatomic,strong)NSString<Optional> *RegionCode;//居住地Code
@property(nonatomic,strong)NSString<Optional> *Hukou;//户口所在地
@property(nonatomic,strong)NSString<Optional> *HukouKey;//户口所在地Code
@property(nonatomic,strong)NSString<Optional> *NativeCity;//籍贯城市
@property(nonatomic,strong)NSString<Optional> *NativeCityKey;//籍贯城市编码
@property(nonatomic,strong)NSString<Optional> *Health;//健康状况
@property(nonatomic,strong)NSString<Optional> *PhotoUrl;//个人照片
@property(nonatomic,strong)NSNumber<Optional> *Height;//身高
@property(nonatomic,strong)NSString<Optional> *Politics;//政治面貌
@property(nonatomic,strong)NSString<Optional> *PoliticsKey;//政治面貌Key
@property(nonatomic,strong)NSNumber<Optional> *Marital;//婚姻状况（0 未知 1、未婚 2、已婚）
@property(nonatomic,strong)NSString<Optional> *Birthday;//生日
@property(nonatomic,strong)NSString<Optional> *IdCardNumber;//证件号码
@property(nonatomic,strong)NSString<Optional> *IdCardType;// 证件类型
@property(nonatomic,strong)NSString<Optional> *EnglishName;//	String	英文姓名
@property(nonatomic,strong)NSNumber<Optional> *ResumeLanguage;//	int(1、中文 2 英文)	简历语言
@property(nonatomic,strong)NSString<Optional> *UserId; // 用户Id
@property(nonatomic,strong)NSString<Optional> *JobStatus;//	String	工作状态
@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String	简历编号
@property(nonatomic,strong)NSString<Optional> *ResumeName;//	String	简历名称
@property(nonatomic,strong)NSString<Optional> *ChineseName;//	String	中文姓名
@property(nonatomic,strong)NSNumber<Optional> *Gender;//	Int	性别（0 未知1：男 ，2：女）
@property(nonatomic,strong)NSString<Optional> *Mobile;//	String	联系手机
@property(nonatomic,strong)NSString<Optional> *Email;//	String	联系邮箱
@property(nonatomic,strong)NSString<Optional> *DegreeKey;//	String	学历key
@property(nonatomic,strong)NSString<Optional> *Degree;//	String	学历
@property(nonatomic,strong)NSString<Optional> *SchoolId;//	String	毕业学校ID
@property(nonatomic,strong)NSString<Optional> *School;//	String	毕业学校名称
@property(nonatomic,strong)NSString<Optional> *MajorKey;//	String	专业key
@property(nonatomic,strong)NSString<Optional> *Major;//	String	专业
@property(nonatomic,strong)NSString<Optional> *PhotoUrlPath;// 个人头像
//3.1新增
@property(nonatomic,strong)NSString<Optional> *QQ;// QQ
@property(nonatomic,strong)NSNumber<Optional> *Weight;// 体重(kg)
@property(nonatomic,strong)NSNumber<Optional> *HealthType;// 健康状况类型(健康=1,良好=2,有病史=3)
@property(nonatomic,strong)NSString<Optional> *Nation;// 民族
@property(nonatomic,strong)NSString<Optional> *EmergencyContact;// 紧急联系人
@property(nonatomic,strong)NSString<Optional> *EmergencyContactPhone;// 紧急联系方式
@property(nonatomic,strong)NSNumber<Optional> *IsAllowDistribution;// 是否服从分配(0不服从 1服从)
@property(nonatomic,strong)NSNumber<Optional> *IsHasCET4Score;// 是否有英语四级成绩
@property(nonatomic,strong)NSNumber<Optional> *IsHasCET6Score;// 是否有英语六级成绩
@property(nonatomic,strong)NSNumber<Optional> *IsHasTEM4Score;// 是否有英语专四成绩
@property(nonatomic,strong)NSNumber<Optional> *IsHasTEM8Score;// 是否有英语专八成绩
@property(nonatomic,strong)NSNumber<Optional> *IsHasIELTSScore;// 是否有英语雅思成绩
@property(nonatomic,strong)NSNumber<Optional> *IsHasTOEFLScore;// 是否有英语托福成绩
@property(nonatomic,strong)NSNumber<Optional> *CET4Score;// 英语四级成绩
@property(nonatomic,strong)NSNumber<Optional> *CET6Score;// 英语六级成绩
@property(nonatomic,strong)NSNumber<Optional> *TEM4Score;// 英语专四成绩
@property(nonatomic,strong)NSNumber<Optional> *TEM8Score;// 英语专八成绩
@property(nonatomic,strong)NSNumber<Optional> *IELTSScore;// 英语雅思成绩
@property(nonatomic,strong)NSNumber<Optional> *TOEFLScore;// 英语托福成绩

@property(nonatomic,strong)NSMutableArray<PracticeListDataModel> *PracticeList;//	List 实践经历PracticeList
@property(nonatomic,strong)NSMutableArray<ComputerListDataModel> *ComputerList;//	List 计算机等级证书
@property(nonatomic,strong)NSMutableArray<CredentialListDataModel> *CredentialList;//	List 获得证书
@property(nonatomic,strong)NSMutableArray<StudyAchievementListDataModel> *StudyAchievementList;//	List 学习成绩奖励
@property(nonatomic,strong)NSMutableArray<AwardsListDataModel> *AwardsList;//	List 获得奖项
@property(nonatomic,strong)NSMutableArray<StudentLeadersDataModel> *StudentLeadersList;//	List 学生经历
@property(nonatomic,strong)NSMutableArray<LanguageDataModel> *LanguageList;//	List	语言
@property(nonatomic,strong)NSMutableArray<ProjectListDataModel> *ProjectList;//	List	项目经历
@property(nonatomic,strong)NSMutableArray<WorkListDateModel> *WorkList;//	List	工作经历
@property(nonatomic,strong)NSMutableArray<EducationListDateModel> *EducationList;//	List	教育经历
@property(nonatomic,strong)NSMutableArray<SkillDataModel> *SkillList;//	List	专业技能
@property(nonatomic,strong)NSMutableArray<TrainingDataModel> *TrainingList;//	List	培训列表

// 3.2新增
/** 一句话优势的列表 */
@property (nonatomic, strong) NSMutableArray<AttachmentDataModel> *ResumeAttachmentList;
@property (nonatomic, strong) NSString *Introduces;
+ (instancetype)beanFormDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;

-(void)config;
@end

