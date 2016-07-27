//
//  CPAddExpectJobVM.h
//  cepin
//
//  Created by ceping on 16/2/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface CPAddExpectJobVM : BaseRVMViewModel
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
