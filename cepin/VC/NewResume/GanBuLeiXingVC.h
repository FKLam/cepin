//
//  GanBuLeiXingVC.h
//  cepin
//
//  Created by dujincai on 15/6/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface GanBuLeiXingVC : BaseTableViewController
@property(nonatomic,strong)StudentLeadersDataModel *model;
- (instancetype)initWithModel:(StudentLeadersDataModel*)model;
@end
