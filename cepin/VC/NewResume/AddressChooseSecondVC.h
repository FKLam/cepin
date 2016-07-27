//
//  AddressChooseSecondVC.h
//  cepin
//
//  Created by dujincai on 15/6/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface AddressChooseSecondVC : BaseTableViewController
-(instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities model:(ResumeNameModel*)model isJg:(BOOL) isjg;
@end
