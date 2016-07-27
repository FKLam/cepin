//
//  ResumuEditJobExperienceVC.h
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface ResumuEditJobExperienceVC : BaseTableViewController
- (instancetype)initWithModel:(WorkListDateModel*)model isSocial:(BOOL)isSocial;
- (instancetype)initWithModel:(WorkListDateModel *)model isSocial:(BOOL)isSocial resume:(ResumeNameModel *)resume;
@end
