//
//  AddJobStatusVM.h
//  cepin
//
//  Created by dujincai on 15/6/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddJobStatusVM : BaseRVMViewModel
@property(nonatomic,strong)ResumeNameModel *resumeNameModel;
@property(nonatomic,assign)NSNumber *jobNumber;
@property(nonatomic,strong)NSArray *titleArrays;
@property (nonatomic, strong) NSMutableArray *jobStatusArrays;
- (instancetype)initWithResume:(ResumeNameModel*)model;

//- (void)addJobStatus;
@end
