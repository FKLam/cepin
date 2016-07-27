//
//  SubscriptionVC.h
//  cepin
//
//  Created by ricky.tang on 14-10-21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SubscriptionJobModel.h"

@protocol SubscriptionJobVCDelegate <NSObject>

-(void)popViewController;

@end


@interface SubscriptionJobVC : BaseTableViewController
@property(nonatomic,strong)id<SubscriptionJobVCDelegate>delegate;
- (instancetype)initWithModel:(SubscriptionJobModel *)model;
-(void)reloadData;

@end
