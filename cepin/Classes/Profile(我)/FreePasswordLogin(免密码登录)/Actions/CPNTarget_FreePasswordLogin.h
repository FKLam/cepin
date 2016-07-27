//
//  CPNTarget_FreePasswordLogin.h
//  cepin
//
//  Created by ceping on 16/7/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CPNTarget_FreePasswordLogin : NSObject
- (UIViewController *)CPNAction_nativeFreePasswordLoginViewController:(NSDictionary *)params;
- (id)CPNAction_showAlert:(NSDictionary *)params;
@end
