//
//  AddProjectVM.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddProjectVM : BaseRVMViewModel
@property(nonatomic,strong)ProjectListDataModel *projedctModel;
@property(nonatomic,strong)id  deleteCode;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSMutableArray *projectDatas;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;

- (void)getProjectList;

- (void)deleteProjectListWith:(NSString*)ProjectId;
@end
