//
//  UIImage+DrawPicture.m
//  cepin
//
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UIImage+DrawPicture.h"

static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 2;
}


@implementation UIImage (DrawPicture)
//-(UIImage *)drawImageWithSlideType:(RTDrawSlideType)type rect:(CGSize)size lineColor:(UIColor *)color fillColor:(UIColor *)color
//{
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRect:rect];
//    roundedRect.lineWidth = 0;
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
//    [color setFill];
//    [roundedRect fill];
//    [roundedRect stroke];
//    [roundedRect addClip];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
//}
@end
