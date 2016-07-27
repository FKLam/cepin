//
//  AddEducationVM.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddEducationVM : BaseRVMViewModel
@property(nonatomic,strong)EducationListDateModel *eduModel;
@property(nonatomic,strong)id  deleteCode;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSNumber *resumeType;
@property(nonatomic,strong)NSMutableArray *eduDatas;
@property (nonatomic, strong) UIViewController *showMessageVC;
//@property(nonatomic,strong)NSString *workId;

- (instancetype)initWithResumeModel:(ResumeNameModel*)model;

- (void)getEducationList;

- (void)deleteEduListWith:(EducationListDateModel*)model;
@end
