//
//  CPNTarget_PositionRecommend.m
//  cepin
//
//  Created by ceping on 16/7/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_PositionRecommend.h"
#import "CPProfilePositionRecommendController.h"

@implementation CPNTarget_PositionRecommend
- (UIViewController *)CPNAction_nativePositionRecommendViewController:(NSDictionary *)params
{
    CPProfilePositionRecommendController *viewController = [[CPProfilePositionRecommendController alloc] init];
    return viewController;
}
@end
