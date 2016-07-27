//
//  DynamicExamModelDTO.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//
#import "BaseBeanModel.h"

@interface DynamicExamModelDTO : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *ProductId;//	String	测评产品id
@property(nonatomic,strong)NSString<Optional> *UserExamId;//  String	用户测评id
@property(nonatomic,strong)NSString<Optional> *Title;//	String	产品名称
@property(nonatomic,strong)NSString<Optional> *Introduction;//	String	简介
@property(nonatomic,strong)NSString<Optional> *ImgFilePath;//	String	产品图片
@property(nonatomic,strong)NSString<Optional> *ExamUrl;//	String	测评地址
@property(nonatomic,strong)NSString<Optional> *ReportUrl;//	String	测评结果地址
@property(nonatomic,strong)NSString<Optional> *CreateDate;//	String	创建时间
@property(nonatomic,strong)NSString<Optional> *ExamStatus;//	String	测评状态（0：未开始， 1：完成, 2已完成）
@property(nonatomic,strong)NSNumber<Optional> *ExamCount;//	Int	测评人数
@property(nonatomic,strong)NSString<Optional> *SortDate;//	String
@property(nonatomic,strong)NSString<Optional> *Status;//	String
@property(nonatomic,strong)NSString<Optional> *FinishExamTime;//测评报告时间

@property(nonatomic,strong)NSString<Optional> *Shortname;//公司简称
@property (nonatomic, strong) NSString<Optional> *Applicable;
//@property(nonatomic,strong)NSString<Optional> *Introduction;//	String
//@property (nonatomic, strong) NSString<Optional> *examStatus;   // 1职业测评 2微测评

@property (nonatomic, strong) NSString *Name;

// 3.2
@property (nonatomic, strong) NSString<Optional> *CompanyName;
@property (nonatomic, strong) NSString<Optional> *CompanyShowName;
@property (nonatomic, strong) NSString<Optional> *ExamEndTime;
@property (nonatomic, strong) NSString<Optional> *ExamEndTime2;//有精确时间的的结束时间
@property (nonatomic, strong) NSString<Optional> *ProductName;
@property (nonatomic, strong) NSString<Optional> *ExamStartTime;
@property (nonatomic, strong) NSString<Optional> *ExamFinishTime;
@property (nonatomic, strong) NSString<Optional> *PositionName;
@property (nonatomic, strong) NSString<Optional> *MicroExamLinkUrl;
@property (nonatomic, strong) NSString<Optional> *Type;
@property (nonatomic, strong) NSString<Optional> *Icon;
@property (nonatomic, strong) NSString<Optional> *AppExamUrl;



@end

