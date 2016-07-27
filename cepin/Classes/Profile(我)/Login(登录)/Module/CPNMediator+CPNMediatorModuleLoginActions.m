//
//  CPNMediator+CPNMediatorModuleLoginActions.m
//  cepin
//
//  Created by ceping on 16/7/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModuleLoginActions.h"

NSString * const kCPNMediatorTargetLogin = @"Login";
NSString * const kCPNMediatorActionNativeLoginViewController = @"nativeLoginViewController";

@implementation CPNMediator (CPNMediatorModuleLoginActions)
- (UIViewController *)CPNMediator_viewControllerForLogin:(NSDictionary *)parmas
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetLogin action:kCPNMediatorActionNativeLoginViewController params:parmas];
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
