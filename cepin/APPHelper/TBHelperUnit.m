//
//  TBHelperUnit.m
//  cepin
//
//  Created by Ricky Tang on 14-11-7.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "TBHelperUnit.h"
#import "FileManagerHelper.h"

static NSString *UserLoginData = @"UserLoginData";

@implementation TBHelperUnit
@synthesize userLogin = _userLogin;
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static TBHelperUnit *instance;
    dispatch_once(&onceToken, ^{
        instance = [TBHelperUnit new];
    });
    return instance;
}

+(BOOL)isLogin
{
    if ([[TBHelperUnit shareInstance] userLogin]) {
        return YES;
    }
    return NO;
}


-(void)setUserLogin:(UserLoginDTO *)userLogin
{
    [FileManagerHelper writeObject:userLogin file:UserLoginData folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    
    _userLogin = userLogin;
}

-(UserLoginDTO *)userLogin
{
    if (_userLogin) {
        return _userLogin;
    }
    
    _userLogin = [FileManagerHelper readObjectWithfile:UserLoginData folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    return _userLogin;
}

@end
