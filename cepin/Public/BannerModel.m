//
//  BannerModel.m
//  cepin
//
//  Created by ceping on 15-1-15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BannerModel.h"
#import "FileManagerHelper.h"

@implementation BannerModel

+(BannerModel *)bannerWithDic:(NSDictionary *)dic name:(NSString*)name
{
    NSError *error = nil;
    BannerModel *banner = [[BannerModel alloc] initWithDictionary:dic error:&error];
    
    NSAssert(error == nil, @"UserLogin fail");
    
    NSString *file = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([BannerModel class]),name];
    //保存本地
    [FileManagerHelper writeObject:banner file:file folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    
    return banner;
}


+(BannerModel *)bannerModelFromName:(NSString*)fileName
{
    NSString *file = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([BannerModel class]),fileName];
    return [FileManagerHelper readObjectWithfile:file folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
}

@end
