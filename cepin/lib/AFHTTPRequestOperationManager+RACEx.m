//
//  AFHTTPRequestOperationManager+RACEx.m
//  letsgo
//
//  Created by Ricky Tang on 14-9-22.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "AFHTTPRequestOperationManager+RACEx.h"
//#import "AFURLConnectionOperation+RACSupport.h"
#import "AFURLConnectionOperation+RACSupport.h"

@implementation AFHTTPRequestOperationManager (RACEx)

-(RACSignal *)rac_POST:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber){
        
        AFHTTPRequestOperation *operation = [self POST:path parameters:parameters constructingBodyWithBlock:block success:nil failure:nil];
        
        RACSignal *signal = [operation rac_overrideHTTPCompletionBlock];
        
        [self.operationQueue addOperation:operation];
        
        [signal subscribe:subscriber];
        
        return [RACDisposable disposableWithBlock:^{
            
            [operation cancel];
            
        }];
        
    }];
}

@end
