//
//  HealthVC.h
//  cepin
//
//  Created by dujincai on 15/11/3.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"

@interface HealthVC : BaseTableViewController
@property(nonatomic,strong)ResumeNameModel *model;

- (instancetype)initWithModel:(ResumeNameModel*)model;
@end
