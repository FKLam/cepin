//
//  TrainListVM.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface TrainListVM : BaseRVMViewModel
@property(nonatomic,strong)TrainingDataModel *trainData;
@property(nonatomic,strong)NSString *trainId;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSString *strBeginYear;
@property(nonatomic,strong)NSString *strEndYear;
@property(nonatomic,strong)NSString *strBeginMonth;
@property(nonatomic,strong)NSString *strEndMonth;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeId:(NSString*)resumeId;
- (void)addTrain;
@end
