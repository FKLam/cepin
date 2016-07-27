//
//  CPNTarget_Agreement.m
//  cepin
//
//  Created by ceping on 16/7/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNTarget_Agreement.h"
#import "CepinProtoVC.h"
@implementation CPNTarget_Agreement
- (UIViewController *)CPNAction_nativeAgreementViewController:(NSDictionary *)params
{
    CepinProtoVC *viewController = [[CepinProtoVC alloc] init];
    return viewController;
}
@end
