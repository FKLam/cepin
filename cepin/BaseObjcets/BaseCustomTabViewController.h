//
//  BaseCustomTabViewController.h
//  cepin
//
//  Created by Ricky Tang on 14-11-8.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {

    TabViewDirectionTop,
    TabViewDirectionBottom,
    
}TabViewDirection;

@interface BaseCustomTabViewController : BaseViewController
@property(nonatomic,strong)UIView *tabView;
@property(nonatomic,strong)NSArray *viewControllers;
@property(nonatomic,weak)UIViewController *selectedController;
@property(nonatomic,assign)TabViewDirection direction;//Tab的方向，是在底部，还是在顶部
@property(nonatomic,assign)BOOL isTitleFollowSubController;

-(void)setSwitchViewControllers:(NSArray *)viewControllers;

-(void)swichViewWithIndex:(NSInteger)index;
@end
