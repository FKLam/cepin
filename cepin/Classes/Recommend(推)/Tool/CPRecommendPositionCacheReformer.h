//
//  CPRecommendPositionCacheReformer.h
//  cepin
//
//  Created by ceping on 16/3/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPGuessYouLikePositionParam.h"
@interface CPRecommendPositionCacheReformer : NSObject
+ (void)addRecommendPositionDict:(NSDictionary *)positionDict params:(CPGuessYouLikePositionParam *)params;
+ (void)clearup;
+ (NSDictionary *)positionDictWithParams:(CPGuessYouLikePositionParam *)params;
+ (NSArray *)positionDictsWithParams:(CPGuessYouLikePositionParam *)params;
@end
