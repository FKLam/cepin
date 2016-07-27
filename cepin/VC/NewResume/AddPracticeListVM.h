//
//  AddPracticeListVM.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddPracticeListVM : BaseRVMViewModel
@property(nonatomic,strong)PracticeListDataModel *pracData;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSString *strBeginYear;
@property(nonatomic,strong)NSString *strEndYear;
@property(nonatomic,strong)NSString *strBeginMonth;
@property(nonatomic,strong)NSString *strEndMonth;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeid:(NSString*)resumeid;
- (void)addPractice;
@end
