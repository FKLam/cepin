//
//  CPNMediator+CPNMediatorModuleSignupActions.m
//  cepin
//
//  Created by ceping on 16/7/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModuleSignupActions.h"

NSString * const kCPNMediatorTargetSignup = @"Signup";
NSString * const kCPNMediatorActionNativeSignupViewController = @"nativeSignupViewController";

@implementation CPNMediator (CPNMediatorModuleSignupActions)

- (UIViewController *)CPNMediator_viewControllerForSignup:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetSignup action:kCPNMediatorActionNativeSignupViewController params:params];
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
