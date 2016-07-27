//
//  CPArrowTextField.m
//  cepin
//
//  Created by ceping on 16/2/16.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPArrowTextField.h"

@implementation CPArrowTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat textHeight = bounds.size.height;
    CGFloat textX = bounds.origin.x;
    CGFloat textY = 0;
    CGFloat textMaxWidth = bounds.size.width;
    return CGRectMake(textX, textY, textMaxWidth, textHeight);
}
@end
