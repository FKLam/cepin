//
//  AddExpectJobVM.h
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddExpectJobVM : BaseRVMViewModel
@property(nonatomic,strong)ResumeNameModel *resumeNameModel;
@property(nonatomic,strong)NSMutableArray *jobstates;
@property(nonatomic,strong)NSString *cityKey;
@property(nonatomic,strong)NSString *salaryKey;
@property(nonatomic,strong)NSString *indestryKey;
@property(nonatomic,strong)NSString *typeKey;
@property (nonatomic, strong) id addExpectJob;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;
- (void)saveExpectJob;
@end
