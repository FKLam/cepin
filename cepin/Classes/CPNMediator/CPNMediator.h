//
//  CPNMediator.h
//  cepin
//
//  Created by ceping on 16/7/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNMediator : NSObject
+ (instancetype)sharedInstance;

// 远程App调用入口
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;
// 本地组件调用入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;
@end
