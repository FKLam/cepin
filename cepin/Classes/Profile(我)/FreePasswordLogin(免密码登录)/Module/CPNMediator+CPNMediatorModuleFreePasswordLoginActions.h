//
//  CPNMediator+CPNMediatorModuleFreePasswordLoginActions.h
//  cepin
//
//  Created by ceping on 16/7/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator.h"
#import <UIKit/UIKit.h>

@interface CPNMediator (CPNMediatorModuleFreePasswordLoginActions)
- (UIViewController *)CPNMediator_viewControllerForFreePassword;
- (void)CPNMediator_showAlertWithMessage:(NSString *)message cancelAction:(void(^)(NSDictionary *info))cancelAction confirmAction:(void(^)(NSDictionary *info))confirmAction;
@end
