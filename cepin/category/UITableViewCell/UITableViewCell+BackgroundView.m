//
//  UITableViewCell+BackgroundView.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-8-12.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "UITableViewCell+BackgroundView.h"

@implementation UITableViewCell (BackgroundView)

-(void)setBackgroundViewWith:(UIColor *)color
{
    [self setBackgroundViewWith:color frame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

-(void)setBackgroundViewWith:(UIColor *)color frame:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = color;
    self.backgroundView = view;
}

-(void)setBackgroundViewWithImage:(UIImage *)image
{
    [self setBackgroundViewWithImage:image frame:self.bounds];
}

-(void)setBackgroundViewWithImage:(UIImage *)image frame:(CGRect)rect
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = rect;
    self.backgroundView = imageView;
}

-(void)setSelectedBackgroundViewWithColor:(UIColor *)color
{
    /*UIView *view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = color;
    self.selectedBackgroundView = view;*/
    
    [self setSelectedBackgroundViewWithColor:color frame:self.bounds];
}


-(void)setSelectedBackgroundViewWithColor:(UIColor *)color frame:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = color;
    self.selectedBackgroundView = view;
}


-(void)setSelectedBackgroundViewWithView:(UIView *)view
{
    view.frame = self.bounds;
    [view setNeedsDisplay];
    self.selectedBackgroundView = view;
}


-(void)setSelectedBackgroundViewWithImage:(UIImage *)image
{
    [self setSelectedBackgroundViewWithImage:image frame:self.bounds];
}

-(void)setSelectedBackgroundViewWithImage:(UIImage *)image frame:(CGRect)rect
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = rect;
    self.selectedBackgroundView = imageView;
}

@end
