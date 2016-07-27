//
//  CPNTarget_FreePasswordLogin.m
//  cepin
//
//  Created by ceping on 16/7/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_FreePasswordLogin.h"
#import "CPNFreePWViewController.h"

typedef void (^CPNRouteCallbackBlock)(NSDictionary *info);

@implementation CPNTarget_FreePasswordLogin
- (UIViewController *)CPNAction_nativeFreePasswordLoginViewController:(NSDictionary *)params
{
    // 因为action是从属模块FreePassword的，所以action直接可以使用FreePassword里的所有声明
    CPNFreePWViewController *viewController = [[CPNFreePWViewController alloc] init];
    return viewController;
}
- (id)CPNAction_showAlert:(NSDictionary *)params
{
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        CPNRouteCallbackBlock callback = params[@"cancelAction"];
        if ( callback )
        {
            callback(@{@"alertAction" : action});
        }
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CPNRouteCallbackBlock callback = params[@"confirmAction"];
        if ( callback )
        {
            callback(@{@"alertAction" : action});
        }
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"alert from Module FreePassword" message:params[@"message"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    return nil;
}
@end
