//
//  TBTabViewController.h
//  cepin
//
//  Created by ricky.tang on 14-10-16.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseCustomTabViewController.h"
#import "RTTabView.h"

@interface TBTabViewController : BaseCustomTabViewController

@property(nonatomic,strong)RTTabView *tabBar;
@property (nonatomic, assign) BOOL isTranslate;
@end
