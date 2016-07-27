//
//  TBHelperUnit.h
//  cepin
//
//  Created by Ricky Tang on 14-11-7.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLoginDTO.h"

@interface TBHelperUnit : NSObject
@property(nonatomic,strong)UserLoginDTO *userLogin;

+(instancetype)shareInstance;

+(BOOL)isLogin;

@end
