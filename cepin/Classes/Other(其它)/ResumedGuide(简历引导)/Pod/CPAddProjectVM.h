//
//  CPAddProjectVM.h
//  cepin
//
//  Created by ceping on 16/2/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface CPAddProjectVM : BaseRVMViewModel
@property(nonatomic,strong)WorkListDateModel *workData;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSString *strBeginYear;
@property(nonatomic,strong)NSString *strEndYear;
@property(nonatomic,strong)NSString *strBeginMonth;
@property(nonatomic,strong)NSString *strEndMonth;
@property(nonatomic,strong)NSNumber *resumeType;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeid:(NSString*)resumeid;
- (instancetype)initWithResume:(ResumeNameModel *)resume;
- (void)addWork;
@end
