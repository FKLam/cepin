//
//  UIViewController+Animation.h
//  cepin
//
//  Created by ceping on 15-2-3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (VCtrlAnimation)

+(void)zoomIn: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait;

@end
