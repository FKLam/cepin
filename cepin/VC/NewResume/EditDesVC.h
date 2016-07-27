//
//  EditDesVC.h
//  cepin
//
//  Created by dujincai on 15/6/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface EditDesVC : BaseTableViewController
@property(nonatomic,strong)PracticeListDataModel *model;
- (instancetype)initWithEduModel:(PracticeListDataModel*)model;
@end
