//
//  ResumeAddJobVM.h
//  cepin
//
//  Created by dujincai on 15/6/24.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface ResumeAddJobVM : BaseRVMViewModel
@property(nonatomic,strong)WorkListDateModel *workData;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSString *strBeginYear;
@property(nonatomic,strong)NSString *strEndYear;
@property(nonatomic,strong)NSString *strBeginMonth;
@property(nonatomic,strong)NSString *strEndMonth;
@property(nonatomic,strong)NSNumber *resumeType;
@property (nonatomic, strong) ResumeNameModel *resume;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeid:(NSString*)resumeid;
- (instancetype)initWtihRsume:(ResumeNameModel *)resume;
- (void)addWork;
@end
