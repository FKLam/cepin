//
//  EditEducationVC.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface EditEducationVC : BaseTableViewController
- (instancetype)initWithModel:(EducationListDateModel*)model isSocial:(BOOL)isSocial;
@end
