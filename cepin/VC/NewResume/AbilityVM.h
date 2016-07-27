//
//  AbilityVM.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AbilityVM : BaseRVMViewModel
@property(nonatomic,strong)SkillDataModel *skillModel;
@property(nonatomic,strong)id  deleteCode;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSMutableArray *skillDatas;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;

- (void)getSkillList;

- (void)deleteSkillListWith:(NSString*)skillId;
@end
