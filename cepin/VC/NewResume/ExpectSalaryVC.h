//
//  ExpectSalaryVC.h
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface ExpectSalaryVC : BaseTableViewController
@property(nonatomic,strong)ResumeNameModel *resumeModel;
- (instancetype)initWithModel:(ResumeNameModel*)model;
@end
