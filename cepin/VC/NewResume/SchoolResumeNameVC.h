//
//  SchoolResumeNameVC.h
//  cepin
//
//  Created by dujincai on 15/11/13.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"

@interface SchoolResumeNameVC : BaseTableViewController
- (instancetype)initWithResumeId:(NSString*)resumeId;
- (instancetype)initWithResumeModel:(ResumeNameModel*)resumeModel;

@end
