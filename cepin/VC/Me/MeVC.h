//
//  MeVC.h
//  cepin
//
//  Created by dujincai on 15/6/1.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RTTabView.h"

@interface MeVC : BaseTableViewController
- (void)markComeFrom;
@property(nonatomic,weak)id<RTTabDelegate> tabDelegate;
@end
