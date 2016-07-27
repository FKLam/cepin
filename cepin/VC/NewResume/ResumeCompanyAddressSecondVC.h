//
//  ResumeCompanyAddressSecondVC.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface ResumeCompanyAddressSecondVC : BaseTableViewController
@property(nonatomic,strong)WorkListDateModel *model;
-(instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities model:(WorkListDateModel*)model;
@end
