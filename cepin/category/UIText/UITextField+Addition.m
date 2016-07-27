//
//  UITextField+Addition.m
//  yanyunew
//
//  Created by Ricky Tang on 14-5-4.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "UITextField+Addition.h"

@implementation UITextField (Addition)



-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    // 设置线条颜色
    CGContextSetRGBStrokeColor(ctx, 3.0f/255.0f, 121.0f/255.0f, 241.0f/255.0f, 1.0f);
    
    CGContextMoveToPoint(ctx, 2, rect.size.height-3);
    CGContextAddLineToPoint(ctx, rect.size.width-2, rect.size.height-3);
    
    CGContextMoveToPoint(ctx, 1, rect.size.height-7);
    CGContextAddLineToPoint(ctx, 1, rect.size.height-2);
    
    CGContextMoveToPoint(ctx, rect.size.width-1, rect.size.height-7);
    CGContextAddLineToPoint(ctx, rect.size.width-1, rect.size.height-2);
    // 开始绘图
    CGContextStrokePath(ctx);
}
-(UIButton *)crossButtonWithImage:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender){
        self.text = @"";
    }];
    self.rightView = button;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    return button;
}
@end
