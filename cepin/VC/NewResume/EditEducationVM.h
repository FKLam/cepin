//
//  EditEducationVM.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface EditEducationVM : BaseRVMViewModel
@property(nonatomic,strong)id saveStateCode;
@property(nonatomic,strong)EducationListDateModel *eduData;
@property(nonatomic,strong)NSString *eduId;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSString *strBeginYear;
@property(nonatomic,strong)NSString *strEndYear;
@property(nonatomic,strong)NSString *strBeginMonth;
@property(nonatomic,strong)NSNumber *resumeType;
@property(nonatomic,strong)NSString *strEndMonth;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithWork:(EducationListDateModel*)model;
- (void)saveEdu;

- (void)getEduInfo;
@end
