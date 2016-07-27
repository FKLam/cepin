//
//  RTNetworking.m
//  yanyunew
//
//  Created by Ricky Tang on 14-4-11.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "RTNetworking.h"
#import "RACSignal.h"
#import "RACSubscriber.h"
#import "RACDisposable.h"
//#import <ReactiveCocoa/NSURLConnection+RACSupport.h>



@implementation RTNetworking
+(id)shareInstance
{
    static RTNetworking *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = self.new;
    });
    return shareInstance;
}


- (void)setupNetWorking
{
    [self.httpManager.reachabilityManager stopMonitoring];
    self.httpManager = nil;
    
    self.httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kHostUrl]];
    
    
    [self.httpManager.reachabilityManager startMonitoring];
    [self.httpManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //                    [operationQueue setSuspended:NO];
            {
                //安排重新上传或下载文件
//                if ([RTAppHelper userLogoImage] && [RTAppHelper isLogin]) {
//                    NSUserDefaults *_user = [NSUserDefaults standardUserDefaults];
//                    [[RTNetworking shareInstance] uploadUserLogoWithImage:[RTAppHelper userLogoImage] userId:_user.RT_LoginUserID sucess:^(void){} fail:^(void){}];
//                }
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                //                    [operationQueue setSuspended:YES];
                break;
        }
    }];
    
//    [JSONModel setGlobalKeyMapper:[[JSONKeyMapper alloc] initWithDictionary:@{@"initAmount": @"InitAmount"}]];
}

-(id)init
{
    if (self = [super init]) {
        [self setupNetWorking];
    }
    return self;
}



@end
