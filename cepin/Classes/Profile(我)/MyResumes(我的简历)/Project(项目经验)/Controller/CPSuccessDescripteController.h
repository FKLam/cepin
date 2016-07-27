//
//  CPSuccessDescripteController.h
//  cepin
//
//  Created by ceping on 16/3/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"

@interface CPSuccessDescripteController : BaseTableViewController
@property(nonatomic,strong) ProjectListDataModel *model;
- (instancetype)initWithEduModel:(ProjectListDataModel*)model;
@end
