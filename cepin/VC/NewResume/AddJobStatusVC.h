//
//  AddJobStatusVC.h
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface AddJobStatusVC : BaseTableViewController
@property(nonatomic,strong)ResumeNameModel *resumeNameModel;

- (instancetype)initWithModel:(ResumeNameModel *)model;
@end
