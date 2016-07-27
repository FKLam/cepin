//
//  BaseTabViewController.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-6.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseTabViewController.h"
#import "TabItemButton.h"

NSString *const TabButtonSwitchNotification = @"TabButtonSwitchNotification";

@interface BaseTabViewController ()

@end

@implementation BaseTabViewController
@synthesize isShow,tabViewControllers,tabItems,selectedItem,selectedVC,tabView;

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isShow = YES;
    
    statueBarHeight = 0;
    if (![UIApplication sharedApplication].statusBarHidden) {
        statueBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    [self showAndHide:YES animation:NO complete:nil];
    
    self.view.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    /*if ([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        self.tabViewControllers = nil;
        self.tabItems = nil;
        self.selectedItem = nil;
        self.selectedVC = nil;
        self.tabView = nil;
    }*/
}

-(void)dealloc
{
    self.tabViewControllers = nil;
    self.tabItems = nil;
    self.selectedItem = nil;
    self.selectedVC = nil;
    self.tabView = nil;
}

-(void)setTabItems:(NSMutableArray *)items
{
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
        NSAssert([obj isKindOfClass:[TabItemButton class]], @"obj is not TabItemButton");
        
        if (self.selectedItem == nil && idx == 0) {
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self switchViewWith:obj];
            });
        }
        [(TabItemButton *)obj addTarget:self action:@selector(switchViewWith:) forControlEvents:UIControlEventTouchUpInside];
        [(TabItemButton *)obj setupTabItemButtonNotification:YES];
    }];
    
    tabItems = items;
}

-(NSMutableArray *)tabItems
{
    return tabItems;
}

-(void)setTabViewControllers:(NSMutableArray *)vc
{
    self.selectedVC = [vc objectAtIndex:0];
    tabViewControllers = vc;
}

-(NSMutableArray *)tabViewControllers
{
    return tabViewControllers;
}

-(NSInteger)selectedIndex
{
    return [[self tabItems] indexOfObject:self.selectedItem];
}

-(void)replaceViewControllerWith:(UIViewController *)vc index:(NSInteger)index
{
    UIViewController *uiVC = [self.tabViewControllers objectAtIndex:index];
    [uiVC.view removeFromSuperview];
    
    [self.tabViewControllers replaceObjectAtIndex:index withObject:vc];
    self.selectedVC = vc;
    [self.view insertSubview:self.selectedVC.view belowSubview:self.tabView];
    
    TabItemButton *item = [self.tabItems objectAtIndex:index];
    
    //发送通知给TabItemButton
    [[NSNotificationCenter defaultCenter] postNotificationName:TabButtonSwitchNotification object:item];
    
    self.selectedItem = item;
}

-(void)replaceViewControllerWith:(UIViewController *)vc index:(NSInteger)index display:(BOOL)isDisplay
{
    
    UIViewController *uiVC = [self.tabViewControllers objectAtIndex:index];
    [uiVC.view removeFromSuperview];
    
    [self.tabViewControllers replaceObjectAtIndex:index withObject:vc];
    
     if (!isDisplay) {
        return;
    }
    
    self.selectedVC = vc;
    [self.view insertSubview:self.selectedVC.view belowSubview:self.tabView];
    
    TabItemButton *item = [self.tabItems objectAtIndex:index];
    
    //发送通知给TabItemButton
    [[NSNotificationCenter defaultCenter] postNotificationName:TabButtonSwitchNotification object:item];
    
    self.selectedItem = item;
}


-(IBAction)switchViewWith:(id)tabItem
{
    NSAssert([tabItem isKindOfClass:[TabItemButton class]], @"obj is not TabItemButton");
    
    if (tabItem == self.selectedItem) {
        return;
    }
    
    //发送通知给TabItemButton
    [[NSNotificationCenter defaultCenter] postNotificationName:TabButtonSwitchNotification object:tabItem];
    
    self.selectedItem = tabItem;
    
    NSInteger index = [self.tabItems indexOfObject:tabItem];
    UIViewController *vc = [self.tabViewControllers objectAtIndex:index];
    
    float addHeight = 0;
    if (IS_IPHONE_5) {
        addHeight = IPHONE_5_ADD_HEIGHT;
    }
    
    //CGRect rect = CGRectMake(CGRectGetMinX(vc.view.frame), CGRectGetMinY(vc.view.frame), CGRectGetWidth(vc.view.frame), vc.view.frame.size.height+addHeight);
   // vc.view.frame = rect;
    
    [self.selectedVC.view removeFromSuperview];
    self.selectedVC = vc;
    [self.view insertSubview:self.selectedVC.view belowSubview:self.tabView];
}


-(UIViewController *)switchViewWithIndex:(NSInteger)index
{
    TabItemButton *item = [self.tabItems objectAtIndex:index];
    
    [self switchViewWith:item];
    
    return [self.tabViewControllers objectAtIndex:index];
}


-(void)showAndHide:(BOOL)show animation:(BOOL)animation complete:(void(^)(void))completeBlock
{
    
    isShow = show;
    
    CGRect rect;
    CGRect screenRect = [UIScreen mainScreen].bounds;
    //RTLog(@"screen height %f",screenRect.size.height);
    float tabViewHeight = self.tabView.bounds.size.height;
    float tabViewWidth = self.tabView.bounds.size.width;
    float stauteBarHeight = 0;
    
    if (!IsIOS7) {
        if ([UIApplication sharedApplication].statusBarHidden == NO) {
            stauteBarHeight = [UIApplication  sharedApplication].statusBarFrame.size.height;
        }
        
        if ([[[UIDevice currentDevice] systemVersion] integerValue] > 7) {
            stauteBarHeight = 0;
        }
    }
    
    
    
    if(isShow){
        rect = CGRectMake(0, screenRect.size.height-tabViewHeight-stauteBarHeight, tabViewWidth, tabViewHeight);
    }
    else{
        rect = CGRectMake(0, screenRect.size.height+tabViewHeight+stauteBarHeight, tabViewWidth, tabViewHeight);
    }

    if (animation) {
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            
            //RTLog(@"tabView y %f",rect.origin.y);
            self.tabView.frame = rect;
            
        } completion:^(BOOL finished){
            [[NSNotificationCenter defaultCenter] postNotificationName:TabViewShowOrHideAnimationFinishedNotification object:self];
            [self finishedShowOrHideAnimation];
            
            if (completeBlock) {
                completeBlock();
            }
        }];
    }
    else{
        self.tabView.frame = rect;
        
        if (completeBlock) {
            completeBlock();
        }
    }
    
}



-(void)finishedShowOrHideAnimation{}

@end
