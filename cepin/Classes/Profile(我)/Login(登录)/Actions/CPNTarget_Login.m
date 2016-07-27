//
//  CPNTarget_Login.m
//  cepin
//
//  Created by ceping on 16/7/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_Login.h"
#import "LoginVC.h"

@implementation CPNTarget_Login
- (UIViewController *)CPNAction_nativeLoginViewController:(NSDictionary *)params
{
    NSString *comfromString = params[@"comfrom"];
    LoginVC *viewController = [[LoginVC alloc] initWithComeFromString:comfromString];
    return viewController;
}
@end
