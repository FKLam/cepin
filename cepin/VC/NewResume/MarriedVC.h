//
//  MarriedVC.h
//  cepin
//
//  Created by dujincai on 15/6/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface MarriedVC : BaseTableViewController
@property(nonatomic,strong)ResumeNameModel *model;
- (instancetype)initWithModel:(ResumeNameModel*)model;
@end