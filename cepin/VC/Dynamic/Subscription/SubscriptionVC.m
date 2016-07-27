//
//  SubScriptionVC.m
//  cepin
//
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SubscriptionVC.h"
#import "UIViewController+NavicationUI.h"
#import "SubscriptionJobVC.h"
#import "SubscriptionTalkInVC.h"
#import "TalkInFilterModel.h"
#import "BookingJobFilterModel.h"

@interface SubscriptionVC ()
@property(nonatomic,weak)UISegmentedControl *segmented;
@property(nonatomic,strong)NSArray *viewControllers;
@property(nonatomic,weak)UIViewController *selectedController;

-(void)clickedSegmented:(id)seg;
@end

@implementation SubscriptionVC

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (self.segmented.selectedSegmentIndex == 0)
        {
            //删除工作订阅
            //[[BookingJobFilterModel shareInstance]deleteObjectFromDisk];
            SubscriptionJobVC *vc = _viewControllers[0];
            [vc reloadData];
        }
        else
        {
            //删除宣讲会订阅
            //[[TalkInFilterModel shareInstance]deleteObjectFromDisk];
            SubscriptionTalkInVC *vc = _viewControllers[1];
            [vc reloadData];
        }
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    
    self.segmented = [self addNavicationBarCenterSegmented];
    
    @weakify(self);
    [[[self addNavicationObjectWithType:NavcationBarObjectTypeDelete] rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        @strongify(self);
        NSString *str = @"是否删除工作订阅的设置";
        if (self.segmented.selectedSegmentIndex == 1)
        {
            str = @"是否删除宣讲会设置";
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    
    //- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
    [self.segmented setSelectedSegmentIndex:0];
    [self.segmented addTarget:self action:@selector(clickedSegmented:) forControlEvents:UIControlEventValueChanged];
    
    [self setViewControllers:@[[SubscriptionJobVC new],[SubscriptionTalkInVC new]]];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (self.view.window == nil && [self isViewLoaded]) {
        self.segmented = nil;
        self.viewControllers = nil;
        self.selectedController = nil;
    }
}

-(void)clickedSegmented:(id)seg
{
    [self swichViewWithIndex:self.segmented.selectedSegmentIndex];
}


-(void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    
    for (UIViewController *vc in self.viewControllers) {
        [self addChildViewController:vc];
    }
    
    [self swichViewWithIndex:0];
}

-(void)swichViewWithIndex:(NSInteger)index
{
    UIViewController *v1 = _viewControllers[index];
    
    [self.selectedController.view removeFromSuperview];
    
    [self.view addSubview:v1.view];
    
    [self.view sendSubviewToBack:v1.view];
    
    self.title = v1.title;
    
    //    CGRect rect = [self.navigationController.navigationBar convertRect:self.navigationController.navigationBar.frame toView:self.view];
    //
    //    RTLog(@"rect %@",NSStringFromCGRect(rect));
    
    [v1.view mas_makeConstraints:^(MASConstraintMaker *maker){
        
        maker.left.equalTo(self.view.mas_left);
        maker.right.equalTo(self.view.mas_right);
        maker.top.equalTo((IsIOS7)?@(0):@(44));
        maker.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
    [self didMoveToParentViewController:v1];
    
    self.selectedController = v1;
}

@end
