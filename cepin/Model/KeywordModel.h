//
//  KeywordModel.h
//  cepin
//
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "JSONModel+Sqlite.h"

@interface KeywordModel : JSONModel
@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)NSDate *createDate;
@property (nonatomic, strong) NSString *userID;


+(NSMutableArray *)keywordsWithString:(NSString *)string;

+(NSMutableArray *)allKeywords;

+(BOOL)saveKeywordWith:(NSString *)keyword;

+ (BOOL)saveKeywordWith:(NSString *)keyword userID:(NSString *)userID;

+(void)deleteKeyWord:(NSString*)keyWord;

+(instancetype)beanFromDictionary:(NSDictionary*)dic;
@end
