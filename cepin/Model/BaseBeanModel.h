//
//  BaseBeanModel.h
//  cepin
//
//  Created by ceping on 14-12-4.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"

@interface BaseBeanModel : JSONModel

//+(id)beanFromDictionary:(NSDictionary*)dic;
+(instancetype)beanFromDictionary:(NSDictionary*)dic;

@end
