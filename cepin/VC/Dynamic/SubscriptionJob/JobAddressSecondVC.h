//
//  JobAddressSecondVC.h
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SubscriptionJobModel.h"
@interface JobAddressSecondVC : BaseTableViewController
@property(nonatomic,strong)SubscriptionJobModel *model;
-(instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities model:(SubscriptionJobModel*)model;
@end
