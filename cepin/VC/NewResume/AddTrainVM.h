//
//  AddTrainVM.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddTrainVM : BaseRVMViewModel
@property(nonatomic,strong)TrainingDataModel *trainModel;
@property(nonatomic,strong)id  deleteCode;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSMutableArray *trainDatas;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;

- (void)getTrainList;

- (void)deleteTrainListWith:(NSString*)TrainId;
@end
