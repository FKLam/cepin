//
//  JSONModelSqlString.h
//  yanyunew
//
//  Created by Ricky Tang on 14-7-4.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONModelSqlString : NSObject

+(NSString *)sqlLikeWithColummName:(NSString *)name string:(NSString *)string;

@end
