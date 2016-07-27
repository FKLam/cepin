//
//  UIView+RowHeight.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-8-11.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RowHeight)

-(CGFloat) getGrowTheHeightWith:(NSString *)content contentWidth:(CGFloat)contentWidth minHeight:(CGFloat)minHeight font:(UIFont *)font;

@end
