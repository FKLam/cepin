//
//  UserLoginDTO.m
//  cepin
//
//  Created by ricky.tang on 14-10-13.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UserLoginDTO.h"
#import "FileManagerHelper.h"
#import "MJExtension.h"
@implementation UserLoginDTO
+ (UserLoginDTO *)userLoginWithDictionary:(NSDictionary *)dic
{
    NSError *error = nil;
    UserLoginDTO *login = [[UserLoginDTO alloc] initWithDictionary:dic error:&error];
    NSAssert(error == nil, @"UserLogin fail");
    if(nil==login || NULL == login || !login){
        return nil;
    }
    //保存本地
    [FileManagerHelper writeObject:login file:NSStringFromClass([UserLoginDTO class]) folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    return [login copy];
}
+ (UserLoginDTO *)info
{
    return [FileManagerHelper readObjectWithfile:NSStringFromClass([UserLoginDTO class]) folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
}
+ (instancetype)beanFromDictionary:(NSDictionary *)dic
{
    return [[self class] objectWithKeyValues:dic];
}
@end
