//
//  CPNMediator+CPNMediatorModuleChangePWActions.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModuleChangePWActions.h"
NSString * const kCPNMediatorTargetChangePW = @"ChangePW";
NSString * const kCPNMediatorActionNativeChangePWViewController = @"nativeChangePWViewController";
@implementation CPNMediator (CPNMediatorModuleChangePWActions)
- (UIViewController *)CPNMediator_viewControllerForChangePW
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetChangePW action:kCPNMediatorActionNativeChangePWViewController params:nil];
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
