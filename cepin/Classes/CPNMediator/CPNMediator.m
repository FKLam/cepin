//
//  CPNMediator.m
//  cepin
//
//  Created by ceping on 16/7/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNMediator.h"

@implementation CPNMediator

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static CPNMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[CPNMediator alloc] init];
    });
    return mediator;
}
/*
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{
    NSString *appScheme = @"Talebase";
    if ( ![url.scheme isEqualToString:appScheme] )
    {
        // 这里就是针对远程App调用404的简单处理，根据不同App的要求不同，可以在这里自己做需要的逻辑
        return @(NO);
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for ( NSString *param in [urlString componentsSeparatedByString:@"&"] )
    {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if ( [elts count] < 2)
            continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    // 下面为安全做的处理
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ( [actionName hasPrefix:@"native"] )
        return @(NO);
    // 这对URL的路由处理，就只是取对应的target名字和method名字，但这已经足以应对绝大部分需求，如果需要拓展，可以在这个方法调用之前加入碗中的路由逻辑
    id result = [self performTarget:url.host action:actionName params:params];
    if ( completion )
    {
        if ( result )
            completion(@{@"result" : result});
        else
            completion( nil );
    }
    return result;
}
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params
{
    NSString *targetClassString = [NSString stringWithFormat:@"CPNTarget_%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"CPNAction_%@:", actionName];
    Class targetClass = NSClassFromString(targetClassString);
    id target = [[targetClass alloc] init];
    SEL action = NSSelectorFromString(actionString);
    if ( target == nil )
    {
        // 这里是处理无响应请求的地方之一
        return nil;
    }
    if ( [target respondsToSelector:action] )
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    }
    else
    {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ( [target respondsToSelector:action] )
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
        }
        else
        {
            return nil;
        }
    }
    
}
@end
