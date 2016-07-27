//
//  UIView+Draw.h
//  Daishu
//
//  Created by Ricky Tang on 14-3-19.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Draw)
-(void)drawSeparatorWithRect:(CGRect)rect color:(UIColor *)color;

-(void)drawSeparatorLongWithRect:(CGRect)rect color:(UIColor *)color;

-(void)drawSeparatorAboveWithRect:(CGRect)rect color:(UIColor *)color;

-(void)drawSeparatorAboveLongWithRect:(CGRect)rect color:(UIColor *)color;

-(void)drawVerticalLineSeparatorWithRect:(CGRect)rect color:(UIColor *)color;

-(void)drawDeleteLineWithRect:(CGRect)rect color:(UIColor *)color;
@end
