//
//  CPPositionDetailCacheReformer.h
//  cepin
//
//  Created by ceping on 16/3/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPPositionDetailParam.h"
@interface CPPositionDetailCacheReformer : NSObject
+ (void)addGuessYouLikePositionDict:(NSDictionary *)positionDict params:(CPPositionDetailParam *)params;
+ (NSArray *)positionDictsWithParams:(CPPositionDetailParam *)parmas;
+ (NSDictionary *)positionDictWithParams:(CPPositionDetailParam *)params;
+ (void)clearup;
@end
