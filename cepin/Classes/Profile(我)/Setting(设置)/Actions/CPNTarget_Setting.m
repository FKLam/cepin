//
//  CPNTarget_Setting.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_Setting.h"
#import "AboutVC.h"

@implementation CPNTarget_Setting
- (UIViewController *)CPNAction_nativeSettingViewController:(NSDictionary *)params
{
    AboutVC *viewController = [[AboutVC alloc] init];
    return viewController;
}
@end
