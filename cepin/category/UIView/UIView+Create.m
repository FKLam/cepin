//
//  UIView+Create.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-8-2.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "UIView+Create.h"

@implementation UIView (Create)
+(id)viewCreateFromClassString:(NSString *)string
{
    return [[[NSBundle mainBundle] loadNibNamed:string  owner:nil options:nil] objectAtIndex:0];
}

+(id)viewCreateFromClass:(Class)class
{
    return [self viewCreateFromClassString:NSStringFromClass(class)];
}
@end
