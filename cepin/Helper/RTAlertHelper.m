//
//  RTAlertHelper.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-8-15.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "RTAlertHelper.h"

@implementation RTAlertHelper
+(void)alertWithMessage:(NSString *)msg
{
    [self alertWithTitle:nil message:msg];
}

+(void)alertWithTitle:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alerView show];
}
@end
