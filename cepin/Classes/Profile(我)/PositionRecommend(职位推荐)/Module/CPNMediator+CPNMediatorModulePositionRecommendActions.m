//
//  CPNMediator+CPNMediatorModulePositionRecommendActions.m
//  cepin
//
//  Created by ceping on 16/7/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModulePositionRecommendActions.h"
NSString * const kCPNMediatorTargetPositionRecommend = @"PositionRecommend";
NSString * const kCPNMediatorActionNativePositionRecommendViewController = @"nativePositionRecommendViewController";
@implementation CPNMediator (CPNMediatorModulePositionRecommendActions)
- (UIViewController *)CPNMediator_viewControllerForPositionRecommend
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetPositionRecommend action:kCPNMediatorActionNativePositionRecommendViewController params:nil];
    if ( [viewController isKindOfClass:[UIViewController class]] )
    {
        return viewController;
    }
    else
    {
        return [[UIViewController alloc] init];
    }
}
@end
