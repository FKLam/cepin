//
//  CPNTarget_Feedback.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_Feedback.h"
#import "CPFeedBackController.h"
@implementation CPNTarget_Feedback
- (UIViewController *)CPNAction_nativeFeedbackViewController:(NSDictionary *)params
{
    CPFeedBackController *viewController = [[CPFeedBackController alloc] init];
    return viewController;
}
@end
