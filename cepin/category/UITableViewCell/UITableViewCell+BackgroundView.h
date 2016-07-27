//
//  UITableViewCell+BackgroundView.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-8-12.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (BackgroundView)

-(void)setBackgroundViewWith:(UIColor *)color;

-(void)setBackgroundViewWith:(UIColor *)color frame:(CGRect)rect;

-(void)setBackgroundViewWithImage:(UIImage *)image;

-(void)setBackgroundViewWithImage:(UIImage *)image frame:(CGRect)rect;

-(void)setSelectedBackgroundViewWithColor:(UIColor *)color;

-(void)setSelectedBackgroundViewWithColor:(UIColor *)color frame:(CGRect)rect;

-(void)setSelectedBackgroundViewWithView:(UIView *)view;

-(void)setSelectedBackgroundViewWithImage:(UIImage *)image;

-(void)setSelectedBackgroundViewWithImage:(UIImage *)image frame:(CGRect)rect;

@end
