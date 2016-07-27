//
//  CPNMediator+CPNMediatorModuleFeedbackActions.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModuleFeedbackActions.h"

NSString * const kCPNMediatorTargetFeedback = @"Feedback";
NSString * const kCPNMediatorActionNativeFeedbackViewController = @"nativeFeedbackViewController";

@implementation CPNMediator (CPNMediatorModuleFeedbackActions)
- (UIViewController *)CPNMediator_viewControllerForFeedback
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetFeedback action:kCPNMediatorActionNativeFeedbackViewController params:nil];
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
