//
//  ExpectAddressSecendVC.h
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"

@interface ExpectAddressSecendVC : BaseTableViewController
-(instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities model:(ResumeNameModel*)model;
@end
