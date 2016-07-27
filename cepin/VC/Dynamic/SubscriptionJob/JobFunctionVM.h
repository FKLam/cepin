//
//  JobFunctionVM.h
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "BookingJobFilterModel.h"
#import "BaseCodeDTO.h"
#import "SubscriptionJobModel.h"

@interface JobFunctionVM : BaseRVMViewModel

@property(nonatomic, strong)NSString *functions;
@property(nonatomic, strong)NSString *functionKeys;
@property(nonatomic,strong)NSMutableArray *jobFunctions;
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,assign)BOOL isShrink;
@property (nonatomic, assign, getter = isOpened) BOOL opened;//开 关
@property(nonatomic,weak)NSMutableArray *selectedObject;
@property(nonatomic,strong)NSMutableArray *jobFunctionsKey;

- (instancetype)initWithJobModel:(SubscriptionJobModel*)model;
@end
