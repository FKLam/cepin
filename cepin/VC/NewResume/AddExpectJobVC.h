//
//  AddExpectJobVC.h
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface AddExpectJobVC : BaseTableViewController
- (instancetype)initWithModel:(ResumeNameModel*)model isSocial:(Boolean)isSocial;
@end
