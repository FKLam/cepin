//
//  StudentListVM.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface StudentListVM : BaseRVMViewModel
@property(nonatomic,strong)StudentLeadersDataModel *studModel;
@property(nonatomic,strong)id  deleteCode;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSMutableArray *studDatas;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;

- (void)getStudentList;

- (void)deleteStudentListWith:(NSString*)studentId;
@end
