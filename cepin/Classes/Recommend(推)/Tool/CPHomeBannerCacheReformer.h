//
//  CPHomeBannerCacheReformer.h
//  cepin
//
//  Created by ceping on 16/3/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPGuessYouLikePositionParam.h"
@interface CPHomeBannerCacheReformer : NSObject
+ (void)addBannerDict:(NSDictionary *)positionDict params:(CPGuessYouLikePositionParam *)params;
+ (NSArray *)bannerDictsWithParams:(CPGuessYouLikePositionParam *)parmas;
+ (void)clearup;
@end
