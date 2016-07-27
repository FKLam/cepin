//
//  UIViewController+Animation.m
//  cepin
//
//  Created by ceping on 15-2-3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "UIViewController+Animation.h"


@implementation UIViewController (VCtrlAnimation)

+(void)zoomIn: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait
{
    __block BOOL done = wait;
    view.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        done = NO;
    }];
    while (done == YES)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}

@end
