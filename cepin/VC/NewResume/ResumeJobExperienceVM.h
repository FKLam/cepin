//
//  ResumeJobExperienceVM.h
//  cepin
//
//  Created by dujincai on 15/6/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"

@interface ResumeJobExperienceVM : BaseRVMViewModel
@property(nonatomic,strong)id  deleteCode;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSMutableArray *jobDatas;
@property(nonatomic,strong)NSString *workId;
@property(nonatomic,strong)WorkListDateModel *workModel;
@property (nonatomic, strong) ResumeNameModel *resume;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;

- (void)getWorkList;

- (void)deleteWorkListWith:(NSString*)workId;
@end
