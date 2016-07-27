//
//  CPGuessYouLikePositionCacheReformer.h
//  cepin
//
//  Created by ceping on 16/3/10.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPGuessYouLikePositionParam.h"
#import "CPRecommendModelFrame.h"
@interface CPGuessYouLikePositionCacheReformer : NSObject
+ (void)addGuessYouLikePosition:(CPRecommendModelFrame *)positionDict params:(CPGuessYouLikePositionParam *)params;
+ (CPRecommendModelFrame *)positionDictWithParams:(CPGuessYouLikePositionParam *)params;
+ (void)addGuessYouLikePositionDict:(NSDictionary *)positionDict params:(CPGuessYouLikePositionParam *)params;
+ (NSArray *)positionDictsWithParams:(CPGuessYouLikePositionParam *)parmas;
+ (void)clearup;
@end
