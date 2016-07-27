//
//  JobSearchVC.h
//  cepin
//
//  Created by ricky.tang on 14-10-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"



@interface JobSearchVC : BaseTableViewController
- (instancetype)initWithKeyWord:(NSString *)keyWord;
- (instancetype)initWithKeyWord:(NSString *)keyWord city:(NSString *)city JobFunction:(NSString *)JobFunction
                         Salary:(NSString *)Salary PositionType:(NSString *)PositionType EmployType:(NSString *)EmployType WorkYear:(NSString *)WorkYear
                         Degree:(NSString *)Degree;


@end
