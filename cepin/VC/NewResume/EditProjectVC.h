//
//  EditProjectVC.h
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface EditProjectVC : BaseTableViewController
- (instancetype)initWithModel:(ProjectListDataModel*)model;
- (instancetype)initWithModel:(ProjectListDataModel *)model resume:(ResumeNameModel *)resume;
@end
