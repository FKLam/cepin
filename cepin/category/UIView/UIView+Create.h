//
//  UIView+Create.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-8-2.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Create)
+(id)viewCreateFromClassString:(NSString *)string;

+(id)viewCreateFromClass:(Class)class;
@end
