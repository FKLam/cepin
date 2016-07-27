//
//  BaseNavigationViewController.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-5.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "TBAppDelegate.h"
#import "RESideMenu.h"
#import "LoginVC.h"
#import "SaveJobVC.h"
#import "SaveCompanyVC.h"
#import "SendResumeVC.h"
#import "UserInfoVC.h"
#import "JobDetailVC.h"
#import "SignupVC.h"
#import "TBTabViewController.h"
#import "AllResumeVC.h"
#import "SaveVC.h"
#import "REFrostedViewController.h"
#import "DynamicExamVC.h"
#import "DynamicSystemVC.h"
#import "JobSearchResultVC.h"
#import "TBTabViewController.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"
#import "SignupGuideResumeVC.h"
#import "SignupExpectJobVC.h"
#import "SignupEducationVC.h"
#import "SignupProjectVC.h"
#import "SubscriptionJobVC.h"
#import "NewJobDetialVC.h"
#import "NOQQVC.h"
#import "JobFunctionVC.h"
#import "ExpectFunctionVC.h"
#import "ResumeNameVC.h"
#import "DynamicWebVC.h"
#import "DynamicExamDetailVC.h"
#import "CPCommon.h"
@interface BaseNavigationViewController ()<UIGestureRecognizerDelegate>
@end
@implementation BaseNavigationViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        if ( CP_IS_IPHONE_6P )
        {
            [self.navigationBar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize: 46 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor whiteColor] }];
        }
        else
        {
            [self.navigationBar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize: 36 / 2.0], NSForegroundColorAttributeName : [UIColor whiteColor] }];
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)pushViewController:(UIViewController *)vc animated:(BOOL)animated completed:(void(^)(void))completed
{
    [self pushViewController:vc animated:YES];
    self.AnimationCompleted = completed;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)popToRootViewControllerAnimated:(BOOL)animated completed:(void(^)(void))completed
{
    [self popToRootViewControllerAnimated:animated];
    self.AnimationCompleted = completed;
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated completed:(void(^)(void))completed
{
    self.AnimationCompleted = completed;
    return [self popViewControllerAnimated:YES];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated == NO) {
        return;
    }
    if ([navigationController.viewControllers[0] isKindOfClass:[viewController class]])
    {
        return;
    }
    if ([viewController isKindOfClass:[SignupVC class]] || [viewController isKindOfClass:[SubscriptionJobVC class]] || [viewController isKindOfClass:[NOQQVC class]] || [viewController isKindOfClass:[JobFunctionVC class]] || [viewController isKindOfClass:[ExpectFunctionVC class]]|| [viewController isKindOfClass:[DynamicExamDetailVC class]])
    { 
        return;
    }
    if([viewController isKindOfClass:[DynamicWebVC class]])
    {
        viewController.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:viewController selector:@selector(clickedBackBtn:)];
    }
    else
    {
        viewController.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(clickedBackBtn:)];
    }
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.AnimationCompleted) {
        self.AnimationCompleted();
        self.AnimationCompleted = nil;
    }
    //清空数据
}
-(void)pop
{
    NSUInteger count = self.viewControllers.count;
    UIViewController *vc = [self.viewControllers lastObject];
    if ([vc isKindOfClass:[AllResumeVC class]])
    {
        if (count >= 2)
        {
            UIViewController *c = [self.viewControllers objectAtIndex:count - 2];
            if (![c isKindOfClass:[TBTabViewController class]])
            {
                [((AllResumeVC*)vc)memoryRelease];
                [self popViewControllerAnimated:YES];
                return;
            }
        }
    }
    if ([vc isKindOfClass:[UMFeedbackViewController class]]) {
    }
    else if ( [vc isKindOfClass:[BaseViewController class]] )
    {
        [((BaseViewController*)vc) memoryRelease];
    }
    [self popViewControllerAnimated:YES];
}
- (void)clickedBackBtn:(id)sender
{
    [self pop];
}
@end
