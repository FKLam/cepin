//
//  JiangLiJiBieVC.h
//  cepin
//
//  Created by dujincai on 15/6/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface JiangLiJiBieVC : BaseTableViewController
@property(nonatomic,strong)AwardsListDataModel *model;
- (instancetype)initWithEduModel:(AwardsListDataModel*)model;
@end
