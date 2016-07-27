//
//  CPNTarget_Signup.m
//  cepin
//
//  Created by ceping on 16/7/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_Signup.h"
#import "SignupVC.h"

@implementation CPNTarget_Signup

- (UIViewController *)CPNAction_nativeSignupViewController:(NSDictionary *)params
{
    NSString *comfromString = params[@"comfrom"];
    SignupVC *viewController = [[SignupVC alloc] initWithComeFormString:comfromString];
    return viewController;
}

@end
