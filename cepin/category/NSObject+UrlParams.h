//
//  NSObject+UrlParams.h
//  yanyunew
//
//  Created by Ricky Tang on 14-6-20.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UrlParams)

+(id)objectOfClass:(Class)objectClass fromParams:(NSString *)str spliteStr:(NSString *)splite;

+(id)objectOfClass:(Class)objectClass fromParams:(NSString *)str;

@end
