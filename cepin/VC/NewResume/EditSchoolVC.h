//
//  EditSchoolVC.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface EditSchoolVC : BaseTableViewController
@property(nonatomic,strong)EducationListDateModel *model;

- (instancetype)initWithEduModel:(EducationListDateModel*)model;
@end
