//
//  RTAlertHelper.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-8-15.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTAlertHelper : NSObject
+(void)alertWithMessage:(NSString *)msg;

+(void)alertWithTitle:(NSString *)title message:(NSString *)msg;

@end
