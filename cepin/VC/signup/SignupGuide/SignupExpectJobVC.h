//
//  SignupExpectJobVC.h
//  cepin
//
//  Created by dujincai on 15/7/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface SignupExpectJobVC : BaseTableViewController
- (instancetype)initWithModel:(ResumeNameModel*)model isSocial:(Boolean)isSocial;
- (instancetype)initWithModel:(ResumeNameModel *)model isSocial:(Boolean)isSocial comeFromString:(NSString *)comeFromString;
@end
