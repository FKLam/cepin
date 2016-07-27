//
//  AFHTTPRequestOperationManager+RACEx.h
//  letsgo
//
//  Created by Ricky Tang on 14-9-22.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFHTTPRequestOperationManager (RACEx)

-(RACSignal *)rac_POST:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

@end
