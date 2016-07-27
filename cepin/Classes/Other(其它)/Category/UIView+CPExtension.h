//
//  UIView+CPExtension.h
//  cepin
//
//  Created by ceping on 15/11/20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^touchBlock)(UITouch *t, UIView *target);

@interface UIView (CPExtension)

- (float)x;
- (float)y;
- (float)width;
- (float)height;

- (void)setX:(float)x;
- (void)setY:(float)y;
- (void)setWidth:(float)w;
- (void)setHeight:(float)h;

- (float)boundsWidth;
- (float)boundsHeight;
- (void)setBoundsWidth:(float)w;
- (void)setBoundsHeight:(float)h;

@end
