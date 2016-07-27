//
//  RACSignal+Error.m
//  cepin
//
//  Created by Ricky Tang on 14-11-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RACSignal+Error.h"
#import "NSString+Addition.h"
#import "NSError+Custom.h"

@implementation RACSignal (Error)

+(RACSignal *)mobileSignalWithMobile:(NSString *)mobile
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        if ([mobile checkMobileText]) {
            [subscriber sendCompleted];
        }else{
            [subscriber sendError:[NSError errorWithErrorType:ErrorTypeMobile]];
        }
        
        return nil;
        
    }];
}


+(RACSignal *)emailSignalWithEmail:(NSString *)email
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        
        if ([email checkEmailText]) {
            [subscriber sendCompleted];
        }else{
            [subscriber sendError:[NSError errorWithErrorType:ErrorTypeEmail]];
        }
        return nil;
        
    }];
}


+(RACSignal *)passwordSignalWithPassword:(NSString *)password
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        
        if ([password checkPasswordText]) {
            [subscriber sendCompleted];
        }else{
            [subscriber sendNext:[NSError errorWithErrorType:ErrorTypePassword]];
        }
        return nil;
    }];
}



+(RACSignal *)loginCheckWithEmail:(NSString *)email password:(NSString *)password netSignal:(RACSignal *)signal
{
    return [RACSignal combineLatest:@[[RACSignal emailSignalWithEmail:email],[RACSignal passwordSignalWithPassword:password],signal]];
}

@end
