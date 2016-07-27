//
//  FullResumeVC.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//  浏览简历的控制器

#import "BaseTableViewController.h"
#import "AllResumeDataModel.h"
@interface FullResumeVC : BaseTableViewController
- (instancetype)initWithResumeId:(NSString*)resumeId;
@end
