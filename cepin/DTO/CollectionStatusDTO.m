//
//  CollectionStatusDTO.m
//  cepin
//
//  Created by ceping on 14-11-24.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CollectionStatusDTO.h"

@implementation CollectionStatusDTO

+(CollectionStatusDTO *)userInfoWithDictionary:(NSDictionary *)dic
{
    NSError *error = nil;
    CollectionStatusDTO *collection = [[CollectionStatusDTO alloc] initWithDictionary:dic error:&error];
    
    NSAssert(error == nil, @"collection fail");
    
    //保存本地
    //[FileManagerHelper writeObject:info file:NSStringFromClass([UserInfoDTO class]) folder:folder sandBoxFolder:kUseDocumentTypeLibraryCaches];
    
    return collection;
}

@end
