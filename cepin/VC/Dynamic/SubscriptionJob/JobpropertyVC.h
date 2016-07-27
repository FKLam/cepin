//
//  JobpropertyVC.h
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SubscriptionJobModel.h"
@interface JobpropertyVC : BaseTableViewController
@property(nonatomic,strong)SubscriptionJobModel *model;
- (instancetype)initWithJobModel:(SubscriptionJobModel*)model;
@end
