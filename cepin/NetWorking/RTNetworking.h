//
//  RTNetworking.h
//  yanyunew
//
//  Created by Ricky Tang on 14-4-11.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperationManager+RACSupport.h"
#import "RACSignal.h"
#import "AFHTTPRequestOperationManager+RACEx.h"

static NSString *const ResultObjectKey = @"resultObject";
typedef enum {
    DateTypeForFairOver = 0,
    DateTypeForFairTime = -1,
    DateTypeForFairToday = 1,
    DateTypeForFairThree = 3,
    DateTypeForFairWeek = 7,
    DateTypeForFairMouth = 30,
    DateTypeForFairTwoMouths = 60,
    DateTypeForFairAll = 100,
}DateTypeForFair;


typedef enum {
    ScheduleTypeFair = 1,
    ScheduleTypeJobFair,
    ScheduleTypeCustom,
}ScheduleType;

@interface RTNetworking : NSObject
@property(nonatomic,strong)AFHTTPRequestOperationManager *httpManager;

+(id)shareInstance;
-(void)setupNetWorking;

@end
