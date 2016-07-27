//
//  ResumeEditJobExperienceVM.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface ResumeEditJobExperienceVM : BaseRVMViewModel
@property(nonatomic,strong)id saveStateCode;
@property(nonatomic,strong)WorkListDateModel *workData;
@property(nonatomic,strong)NSNumber *resumeType;
@property(nonatomic,strong)NSString *workId;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSString *strBeginYear;
@property(nonatomic,strong)NSString *strEndYear;
@property(nonatomic,strong)NSString *strBeginMonth;
@property(nonatomic,strong)NSString *strEndMonth;
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (nonatomic, strong) ResumeNameModel *resume;
- (instancetype)initWithWork:(WorkListDateModel*)model;
- (instancetype)initWithResume:(ResumeNameModel *)resume work:(WorkListDateModel *)work;
- (void)saveWork;
- (void)getWorkInfo;
//- (instancetype)initWithResume:(ResumeNameModel *)resume;
@end
