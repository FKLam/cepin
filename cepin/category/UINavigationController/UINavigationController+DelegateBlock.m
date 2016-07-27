//
//  UINavigationController+DelegateBlock.m
//  yanyu
//
//  Created by rickytang on 13-10-10.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "UINavigationController+DelegateBlock.h"
#import <objc/runtime.h>

static char blockWillShow;
static char blockDidShow;

@implementation UINavigationController (DelegateBlock)

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated willShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))willShowBlock didShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))didShowBlock
{
    [self navigationAnimationWillShow:willShowBlock didShow:didShowBlock];
    [self pushViewController:viewController animated:animated];
}

-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated willShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))willShowBlock didShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))didShowBlock
{
    [self navigationAnimationWillShow:willShowBlock didShow:didShowBlock];
    return [self popToRootViewControllerAnimated:animated];
}


-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated willShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))willShowBlock didShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))didShowBlock
{
    [self navigationAnimationWillShow:willShowBlock didShow:didShowBlock];
    return [self popToViewController:viewController animated:animated];
}


-(void)navigationAnimationWillShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))willShowBlock didShow:(void(^)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated))didShowBlock
{
    self.delegate = self;
    
    if (willShowBlock) {
        objc_setAssociatedObject(self, &blockWillShow, willShowBlock, OBJC_ASSOCIATION_COPY);
    }
    
    if (didShowBlock) {
        objc_setAssociatedObject(self, &blockDidShow, didShowBlock, OBJC_ASSOCIATION_COPY);
    }
}

-(void)removeHandler
{
    self.delegate = nil;
    objc_setAssociatedObject(self, &blockWillShow, nil, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, &blockDidShow, nil, OBJC_ASSOCIATION_COPY);
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.delegate == nil) {
        return;
    }
    
    void(^block)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated) = objc_getAssociatedObject(self, &blockWillShow);
    
    if (block) {
         block(navigationController,viewController,animated);
    }
   
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.delegate == nil) {
        return;
    }
    
    void(^block)(UINavigationController  *navigationController,UIViewController *viewController,BOOL animated) = objc_getAssociatedObject(self, &blockDidShow);
    
    if (block) {
        block(navigationController,viewController,animated);
    }
}


@end
