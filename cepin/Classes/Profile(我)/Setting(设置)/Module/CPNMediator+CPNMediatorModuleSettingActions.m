//
//  CPNMediator+CPNMediatorModuleSettingActions.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModuleSettingActions.h"

NSString * const kCPNMediatorTargetSetting = @"Setting";
NSString * const kCPNMediatorActionNativeSettingViewController = @"nativeSettingViewController";

@implementation CPNMediator (CPNMediatorModuleSettingActions)
- (UIViewController *)CPNMediator_viewControllerForSetting
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetSetting action:kCPNMediatorActionNativeSettingViewController params:nil];
    if ( [viewController isKindOfClass:[UIViewController class]] )
    {
        return viewController;
    }
    else
    {
        // 这里处理异常场景，具体如处理取决于产品
        return [[UIViewController alloc] init];
    }
}
@end
