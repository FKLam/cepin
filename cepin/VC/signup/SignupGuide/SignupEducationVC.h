//
//  SignupEducationVC.h
//  cepin
//
//  Created by dujincai on 15/7/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface SignupEducationVC : BaseTableViewController
- (instancetype)initWithResumeId:(NSString*)resumeId isSocial:(Boolean)isSocial;
- (instancetype)initWithResume:(ResumeNameModel *)resume isSocial:(Boolean)isSocial;
- (instancetype)initWithResume:(ResumeNameModel *)resume isSocial:(Boolean)isSocial comeFromString:(NSString *)comeFromString;
@end
