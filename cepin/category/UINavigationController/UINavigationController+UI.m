//
//  UINavigationController+UI.m
//  cepin
//
//  Created by ricky.tang on 14-10-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UINavigationController+UI.h"

@implementation UINavigationController (UI)

-(UIButton *)addNavicationBarLeftObjectWithImage:(UIImage *)image hightedImage:(UIImage *)hightedImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:hightedImage forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, self.navigationBar.frame.size.height/2-image.size.height/2, image.size.width, image.size.height);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = item;
    
    return btn;
}


-(UIButton *)addNavicationBarRightObjectWithImage:(UIImage *)image hightedImage:(UIImage *)hightedImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:hightedImage forState:UIControlStateHighlighted];
   // [btn setTitle:@"abc" forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.navigationBar.frame.size.width-image.size.width-10, self.navigationBar.frame.size.height/2-image.size.height/2, image.size.width, image.size.height);
   // btn.backgroundColor = [UIColor redColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = item;
    
    return btn;
}

@end
