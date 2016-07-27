//
//  UIView+RowHeight.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-8-11.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "UIView+RowHeight.h"

@implementation UIView (RowHeight)
-(CGFloat) getGrowTheHeightWith:(NSString *)content contentWidth:(CGFloat)contentWidth minHeight:(CGFloat)minHeight font:(UIFont *)font
{
    // 计算出长宽
    CGSize size;
    if (IsIOS7) {
//        -boundingRectWithSize:options:attributes:context:
        size = [content boundingRectWithSize:CGSizeMake(contentWidth,1220) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    }
    else{
        size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1220) lineBreakMode:NSLineBreakByTruncatingTail];
    }

    CGFloat height = size.height;
    if (IsIOS7) {
        height += 5;
    }
    if (size.height <= minHeight) {
        height = 0;
    }
    else{
        height = height-minHeight;
    }
    // 返回需要的高度
    return height;
}
@end
