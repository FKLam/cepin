//
//  BaseTabViewController.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-6.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define TabItemKVO @"TabItemKVO"

#define TabViewShowOrHideAnimationFinishedNotification @"TabViewShowOrHideAnimationFinishedNotification"
//#define TabViewSwitchNotification @"TabViewSwitchNotification"

extern NSString *const TabButtonSwitchNotification;

@class TabItemButton;

@interface BaseTabViewController : UIViewController
{
    float statueBarHeight;
}

@property(nonatomic,assign)BOOL isShow;

@property(nonatomic,strong)NSMutableArray *tabViewControllers;

@property(nonatomic,strong)NSMutableArray *tabItems;

@property(nonatomic,weak)TabItemButton *selectedItem;

@property(nonatomic,readonly,assign)NSInteger selectedIndex;

@property(nonatomic,weak)UIViewController *selectedVC;

@property(nonatomic,strong)IBOutlet UIView *tabView;


-(IBAction)switchViewWith:(id)tabItem;
-(UIViewController *)switchViewWithIndex:(NSInteger)index;
-(void)showAndHide:(BOOL)show animation:(BOOL)animation complete:(void(^)(void))completeBlock;
-(void)finishedShowOrHideAnimation;

-(void)replaceViewControllerWith:(UIViewController *)vc index:(NSInteger)index;

-(void)replaceViewControllerWith:(UIViewController *)vc index:(NSInteger)index display:(BOOL)isDisplay;
@end
