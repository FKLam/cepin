//
//  CPNMediator+CPNMediatorModuleFreePasswordLoginActions.m
//  cepin
//
//  Created by ceping on 16/7/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModuleFreePasswordLoginActions.h"

NSString * const kCPNMediatorTargetFreePasswordLogin = @"FreePasswordLogin";
NSString * const kCPNMediatorActionNativeFreePasswordLoginViewController = @"nativeFreePasswordLoginViewController";
NSString * const kCPNMediatorActionShowAlert = @"showAlert";

@implementation CPNMediator (CPNMediatorModuleFreePasswordLoginActions)
- (UIViewController *)CPNMediator_viewControllerForFreePassword
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetFreePasswordLogin action:kCPNMediatorActionNativeFreePasswordLoginViewController params:nil];
    if ( [viewController isKindOfClass:[UIViewController class]] )
    {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    }
    else
    {
        // 这里处理异常场景，具体如处理取决于产品
        return [[UIViewController alloc] init];
    }
}
- (void)CPNMediator_showAlertWithMessage:(NSString *)message cancelAction:(void (^)(NSDictionary *))cancelAction confirmAction:(void (^)(NSDictionary *))confirmAction
{
    NSMutableDictionary *paramsToSend = [[NSMutableDictionary alloc] init];
    if ( message )
    {
        paramsToSend[@"message"] = message;
    }
    if ( cancelAction )
    {
        paramsToSend[@"cancelAction"] = cancelAction;
    }
    if ( confirmAction )
    {
        paramsToSend[@"confirmAction"] = confirmAction;
    }
    [self performTarget:kCPNMediatorTargetFreePasswordLogin action:kCPNMediatorActionShowAlert params:paramsToSend];
}
@end
