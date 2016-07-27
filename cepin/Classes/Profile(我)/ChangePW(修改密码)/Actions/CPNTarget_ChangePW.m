//
//  CPNTarget_ChangePW.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_ChangePW.h"
#import "ChangePasswardVC.h"

@implementation CPNTarget_ChangePW
- (UIViewController *)CPNAction_nativeChangePWViewController:(NSDictionary *)params
{
    ChangePasswardVC *viewController = [[ChangePasswardVC alloc] init];
    return viewController;
}
@end
