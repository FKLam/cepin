//
//  UIImage+CP.m
//  cepin
//
//  Created by ceping on 15-11-13.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "UIImage+CP.h"

@implementation UIImage (CP)

+ (UIImage *)imageWithName:(NSString *)name
{
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

@end
