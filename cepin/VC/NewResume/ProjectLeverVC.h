//
//  ProjectLeverVC.h
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface ProjectLeverVC : BaseTableViewController
@property(nonatomic,strong)ProjectListDataModel *model;
- (instancetype)initWithEduModel:(ProjectListDataModel*)model;
@end
