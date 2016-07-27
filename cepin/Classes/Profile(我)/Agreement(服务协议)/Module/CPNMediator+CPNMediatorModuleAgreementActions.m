//
//  CPNMediator+CPNMediatorModuleAgreementActions.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModuleAgreementActions.h"
NSString * const kCPNMediatorTargetAgreement = @"Agreement";
NSString * const kCPNMediatorActionNativeAgreementViewController = @"nativeAgreementViewController";
@implementation CPNMediator (CPNMediatorModuleAgreementActions)
- (UIViewController *)CPNMediator_viewControllerForAgreement
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetAgreement action:kCPNMediatorActionNativeAgreementViewController params:nil];
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
