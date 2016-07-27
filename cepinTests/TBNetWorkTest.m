//
//  TBNetWorkTest.m
//  cepin
//
//  Created by peng on 14-11-13.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

/*#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RTNetworking+User.h"

@interface TBNetWorkTest : XCTestCase

@end

@implementation TBNetWorkTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
// 测试登录接口
- (void)testSignUp {
    // This is an example of a functional test case.
    XCTestExpectation *exp = [self expectationWithDescription:@"register"];
    
    RACSignal *signal = [[RTNetworking shareInstance] registerWithEmail:@"abcefg111122@163.com" mobile:@"1234567890" userName:@"name" password:@"123456" comeFrom:100];
    
    [signal subscribeNext:^(RACTuple *tuple){
    
        RTLog(@"tuple %@",tuple);
        [exp fulfill];
        
    } error:^(NSError *error){
        
        RTLog(@"error %@",error);
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error){
        
        
        
    }];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end*/
