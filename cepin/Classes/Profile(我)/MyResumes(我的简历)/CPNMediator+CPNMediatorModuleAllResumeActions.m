//
//  CPNMediator+CPNMediatorModuleAllResumeActions.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModuleAllResumeActions.h"
NSString * const kCPNMediatorTargetAllResume = @"AllResume";
NSString * const kCPNMediatorActionNativeAllResumeViewController = @"nativeAllResumeViewController";
@implementation CPNMediator (CPNMediatorModuleAllResumeActions)
- (UIViewController *)CPNMediator_viewControllerForAllResume
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetAllResume action:kCPNMediatorActionNativeAllResumeViewController params:nil];
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
