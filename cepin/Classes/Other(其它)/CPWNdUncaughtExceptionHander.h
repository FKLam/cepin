//
//  CPWNdUncaughtExceptionHander.h
//  cepin
//
//  Created by ceping on 16/4/7.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPWNdUncaughtExceptionHander : NSObject
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
@end
