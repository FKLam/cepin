//
//  UINavigationController+DelegateBlock.h
//  yanyu
//
//  Created by rickytang on 13-10-10.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (DelegateBlock)<UINavigationControllerDelegate>

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated willShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))willShowBlock didShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))didShowBlock;

-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated willShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))willShowBlock didShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))didShowBlock;

-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated willShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))willShowBlock didShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))didShowBlock;

-(void)navigationAnimationWillShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))willShowBlock didShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))didShowBlock;

-(void)removeHandler;
@end
