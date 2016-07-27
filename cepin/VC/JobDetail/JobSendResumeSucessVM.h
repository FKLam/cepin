//
//  JobSendResumeSucessVM.h
//  cepin
//
//  Created by dujincai on 15/6/8.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "PositionIdModel.h"

@interface JobSendResumeSucessVM : BaseTableViewModel
@property(nonatomic,strong)id isExamStateCode;
@property(nonatomic,strong)id examListStateCode;
@property(nonatomic,strong)NSString *positionId;
@property(nonatomic,assign)BOOL isExam;
@property(nonatomic, strong)NSMutableArray *positionIdArray;


- (instancetype)initWithPositionId:(NSString*)positionId;

- (void)isOpenSpeedExam;
- (void)getExamList;

- (void)allPositionId;
@end
