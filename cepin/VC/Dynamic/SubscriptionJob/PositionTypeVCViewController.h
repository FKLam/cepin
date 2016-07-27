//
//  PositionTypeVCViewController.h
//  cepin
//
//  Created by dujincai on 15/11/19.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SubscriptionJobModel.h"
@interface PositionTypeVCViewController : BaseTableViewController
@property(nonatomic,strong)SubscriptionJobModel *model;
- (instancetype)initWithJobModel:(SubscriptionJobModel*)model;
@end
