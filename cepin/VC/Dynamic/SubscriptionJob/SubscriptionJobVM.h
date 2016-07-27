//
//  SubscriptionVM.h
//  cepin
//
//  Created by ricky.tang on 14-10-21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "SubscriptionJobModelDTO.h"
#import "SubscriptionJobModel.h"

@interface SubscriptionJobVM : BaseRVMViewModel

@property(nonatomic,retain)id DeleteStateCode;
@property(nonatomic,retain)id SaveStateCode;
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSArray *placeholders;
@property(nonatomic,strong)SubscriptionJobModel *jobModel;

- (instancetype)initWithSubModel:(SubscriptionJobModel *)model;

@end
