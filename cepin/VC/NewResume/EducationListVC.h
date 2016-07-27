//
//  EducationListVC.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface EducationListVC : BaseTableViewController
- (instancetype)initWithResumeId:(NSString*)resumeId isSocial:(Boolean)isSocial;
- (instancetype)initWithResume:(ResumeNameModel *)resume isSocial:(Boolean)isSocial;
@end
