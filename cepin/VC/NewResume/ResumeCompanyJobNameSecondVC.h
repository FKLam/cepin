//
//  ResumeCompanyJobNameSecondVC.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface ResumeCompanyJobNameSecondVC : BaseTableViewController
@property(nonatomic,strong)WorkListDateModel *model;
-(instancetype)initWithData:(NSMutableArray *)data seletedData:(NSMutableArray *)seletedData model:(WorkListDateModel*)model;
@end
