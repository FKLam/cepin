//
//  ResumeEditDegreeVC.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface ResumeEditDegreeVC : BaseTableViewController
@property(nonatomic,strong)EducationListDateModel *model;

- (instancetype)initWithEduModel:(EducationListDateModel*)model isXueWei:(Boolean)isXueWei;
@end
