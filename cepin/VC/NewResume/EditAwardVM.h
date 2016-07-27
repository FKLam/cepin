//
//  EditAwardVM.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface EditAwardVM : BaseRVMViewModel
@property(nonatomic,strong)id saveStateCode;
@property(nonatomic,strong)AwardsListDataModel *awardData;
@property(nonatomic,strong)NSString *awardId;
@property(nonatomic,strong)NSString *resumeId;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithWork:(AwardsListDataModel*)model;
- (void)saveAward;
@end
