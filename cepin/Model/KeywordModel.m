//
//  KeywordModel.m
//  cepin
//
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "KeywordModel.h"
#import "MJExtension.h"


@implementation KeywordModel

+(KeywordModel *)createKeywordModelWith:(NSString *)keyword
{
    KeywordModel *t = [KeywordModel new];
    t.keyword = keyword;
    t.createDate = [NSDate date];
    return t;
}

+ (KeywordModel *)createKeywordModelWith:(NSString *)keyword userID:(NSString *)userID
{
    KeywordModel *t = [KeywordModel new];
    t.keyword = keyword;
    t.createDate = [NSDate date];
    t.userID = userID;
    return t;
}

+(NSMutableArray *)keywordsWithString:(NSString *)string
{
    return [KeywordModel searchWithWhere:[NSString stringWithFormat:@"keyword LIKE \"%@%@%@\"",@"%@",string,@"%@"] order:nil];
}


+(NSMutableArray *)allKeywords
{
    NSString *tempUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
    if ( !tempUserID )
        tempUserID = @"";
    
    return [KeywordModel searchWithWhere:[NSString stringWithFormat:@"userID = \"%@\"", tempUserID] order:nil];
}
+(BOOL)saveKeywordWith:(NSString *)keyword
{
    NSInteger i = [KeywordModel searchCountWhere:[NSString stringWithFormat:@"keyword = \"%@\"",keyword]];
    
    if (i > 0) {
        return NO;
    }
    
    KeywordModel *k = [KeywordModel createKeywordModelWith:keyword];
    return [k save];
}


+ (BOOL)saveKeywordWith:(NSString *)keyword userID:(NSString *)userID
{
    if ( !userID )
        userID = @"";
    
    NSInteger i = [KeywordModel searchCountWhere:[NSString stringWithFormat:@"keyword = \"%@\" and userID = \"%@\"",keyword, userID]];
    //    NSInteger i = [KeywordModel searchCountWhere:[NSString stringWithFormat:@"keyword = \"%@\"",keyword]];
    
    if (i > 0) {
        return NO;
    }
    
    KeywordModel *k = [KeywordModel createKeywordModelWith:keyword userID:userID];
    return [k save];
}

+(void)deleteKeyWord:(NSString*)keyWord
{
    [self deleteWithWhere:[NSString stringWithFormat:@"keyword = \"%@\"",keyWord]];
}



+(instancetype)beanFromDictionary:(NSDictionary*)dic
{
    
    return [[self class] objectWithKeyValues:dic];
    
}
@end
