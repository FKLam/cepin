//
//  ProjectListVC.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface ProjectListVC : BaseTableViewController
- (instancetype)initWithResumeId:(NSString*)resumeId;
- (instancetype)initWithResume:(ResumeNameModel *)resume;
@end
