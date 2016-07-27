//
//  CPNTarget_AllResume.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_AllResume.h"
#import "AllResumeVC.h"
@implementation CPNTarget_AllResume
- (UIViewController *)CPNAction_nativeAllResumeViewController:(NSDictionary *)params
{
    AllResumeVC *viewController = [[AllResumeVC alloc] init];
    return viewController;
}
@end
