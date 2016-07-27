//
//  BaseNavigationViewController.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-5.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationViewController : UINavigationController<UINavigationControllerDelegate>

@property(nonatomic,copy)void(^AnimationCompleted)(void);

-(void)pushViewController:(UIViewController *)vc animated:(BOOL)animated completed:(void(^)(void))completed;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completed:(void(^)(void))completed;

-(void)popToRootViewControllerAnimated:(BOOL)animated completed:(void(^)(void))completed;

-(void)clickedBackBtn:(id)sender;
@end
