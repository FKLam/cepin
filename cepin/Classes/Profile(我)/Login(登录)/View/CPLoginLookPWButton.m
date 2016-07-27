//
//  CPLoginLookPWButton.m
//  cepin
//
//  Created by ceping on 16/3/8.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPLoginLookPWButton.h"

@implementation CPLoginLookPWButton

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
    CGFloat W = 70 / 3.0;
    CGFloat H = 70 / 3.0;
    CGFloat X = (bounds.size.width - W) / 2.0;
    CGFloat Y = (bounds.size.height - H) / 2.0;
    return CGRectMake(X, Y, W, H);
}

@end
