//
//  BaseCustomTabViewController.m
//  cepin
//
//  Created by Ricky Tang on 14-11-8.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseCustomTabViewController.h"

@interface BaseCustomTabViewController ()

@end

@implementation BaseCustomTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    /*if (self.view.window == nil && [self isViewLoaded])
    {
        self.tabView = nil;
        self.viewControllers = nil;
        self.selectedController = nil;
    }*/
}


-(void)setSwitchViewControllers:(NSArray *)viewControllers
{
    self.viewControllers = viewControllers;
    for (UIViewController *vc in self.viewControllers)
    {
        [self addChildViewController:vc];
    }
    [self swichViewWithIndex:0];
}

-(void)swichViewWithIndex:(NSInteger)index
{
    UIViewController *v1 = self.viewControllers[index];
    
#pragma mark - 判断当前选择与已选择的控制器是否相等
    if ( v1 == self.selectedController )
        return;
    
    [self.selectedController.view removeFromSuperview];
    
    [self.view addSubview:v1.view];
    
    [self.view sendSubviewToBack:v1.view];
    
    if (_isTitleFollowSubController)
    {
        self.title = v1.title;
    }
    CGFloat y = (self.direction == TabViewDirectionBottom)?(IsIOS7?64:44):self.tabView.viewHeight+(IsIOS7?64:44);
    CGRect rect = CGRectMake(0, y, self.view.viewWidth, self.view.viewHeight-self.tabView.viewHeight);
    v1.view.frame = rect;
    self.selectedController = v1;
}
@end
