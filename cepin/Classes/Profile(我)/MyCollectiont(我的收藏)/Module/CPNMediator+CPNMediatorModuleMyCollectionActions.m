//
//  CPNMediator+CPNMediatorModuleMyCollectionActions.m
//  cepin
//
//  Created by ceping on 16/7/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator+CPNMediatorModuleMyCollectionActions.h"
NSString * const kCPNMediatorTargetMyCollection = @"MyCollection";
NSString * const kCPNMediatorActionNativeMyCollectionViewController = @"nativeMyCollectionViewController";
@implementation CPNMediator (CPNMediatorModuleMyCollectionActions)
- (UIViewController *)CPNMediator_viewControllerForMyCollection
{
    UIViewController *viewController = [self performTarget:kCPNMediatorTargetMyCollection action:kCPNMediatorActionNativeMyCollectionViewController params:nil];
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
