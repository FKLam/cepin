//
//  cepinTests.m
//  cepinTests
//
//  Created by tassel.li on 14-10-9.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

/*#import <XCTest/XCTest.h>
#import "RegionDTO.h"
#import "SchoolDTO.h"
#import "BaseCodeDTO.h"
#import "BaseFilterModel.h"
#import "JobFilterModel.h"
#import "BookingJobFilterModel.h"
#import "RACSignal+Error.h"
#import "DynamicDTO.h"

@interface cepinTests : XCTestCase

@end

@implementation cepinTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHotCities
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    NSMutableArray *hots = [Region hotRegions];
    
    XCTAssertNotNil(hots, @"hot fail");
}


-(void)testRegions
{
    NSMutableArray *regions = [Region allRegions];
    
    XCTAssertNotNil(regions, @"");
}


-(void)testCities
{
    NSMutableArray *cities = [Region citiesWithCodePath:@"471.6"];
    
    XCTAssertNotNil(cities, @"");
}


-(void)testSchool
{
    NSMutableArray *schools = [School schoolWithName:@"北京"];
    
    XCTAssertNotNil(schools, @"");
}


-(void)testWorkYears
{
    NSMutableArray *t = [BaseCode workYears];
    
    XCTAssertNotNil(t, @"");
}

-(void)testDegree
{
    NSMutableArray *t = [BaseCode degrees];
    
    XCTAssertNotNil(t, @"");
}


-(void)testPathCodeFind
{
    XCTAssertTrue([@"192.168.0.1" rangeOfString:@"192.168"].length > 0);
    
    XCTAssertFalse([@"192.168.0.1" rangeOfString:@"192.163"].length > 0);
    
    NSArray *t = @[@"192.168.1",@"192.168.2",@"192.169",];
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSString *string in t) {
        if ([string rangeOfString:@"192.168"].length > 0) {
            [temp addObject:string];
        }
    }
    
    XCTAssertTrue(temp.count < 3);
}


//-(void)testWriteObject
//{
//    Region *item1 = [Region new];
//    item1.RegionName = @"avc";
//    
//    Region *item2 = [Region new];
//    item2.RegionName = @"ccc";
//    
//    BaseFilterModel *model = [BaseFilterModel shareInstance];
//    [model.addresses addObject:item1];
//    [model.addresses addObject:item2];
//    
//    XCTAssertTrue([model saveObjectToDisk]);
//    
//    model = [BaseFilterModel loadData];
//    XCTAssertNotNil(model);
//    
//    model;
//}


-(void)testIndustry
{
    NSMutableArray *temp = [BaseCode industry];
    
    XCTAssertNotNil(temp, @"");
}


-(void)testIndustrySecond
{
//    NSMutableArray *temp = [BaseCode SecondLevelIndustryWithPathCode:<#(NSString *)#>];
}


-(void)testSchoolAddress
{
    NSMutableArray *schools = [School schoolAddress];
    
    XCTAssertNotNil(schools, @"");
}


-(void)testSchools
{
    NSMutableArray *schools = [School schoolsWithProvince:@"上海"];
    
    XCTAssertNotNil(schools, @"");
}


-(void)testWriteJobFilter
{
    Region *item1 = [Region new];
    item1.RegionName = @"avc";
    
    Region *item2 = [Region new];
    item2.RegionName = @"ccc";
    
    JobFilterModel *model = [JobFilterModel shareInstance];
    [model.addresses addObject:item1];
    [model.addresses addObject:item2];
    
    XCTAssertTrue([model saveObjectToDisk]);
    
    XCTAssertNotNil([JobFilterModel loadData]);
    
    model;
}


-(void)testWriteBookingJobFilter
{
    Region *item1 = [Region new];
    item1.RegionName = @"avc";
    
    Region *item2 = [Region new];
    item2.RegionName = @"ccc";
    
    BookingJobFilterModel *model = [BookingJobFilterModel shareInstance];
    [model.addresses addObject:item1];
    [model.addresses addObject:item2];
    
    XCTAssertTrue([model saveObjectToDisk]);
    
    model = [BookingJobFilterModel loadData];
    XCTAssertNotNil(model);
    
    model;
}


-(void)testContactSignal
{
//    RACSignal *signal = [[RACSignal mobileSignalWithMobile:@"18922718"] concat:[RACSignal emailSignalWithEmail:@"1"]];
//    RACSignal *signal = [RACSignal combineLatest:@[[RACSignal mobileSignalWithMobile:@"18922718224"],[RACSignal emailSignalWithEmail:@"1"]]];
    RACSignal *signal = [[RACSignal mobileSignalWithMobile:@"1892"] then:^RACSignal *(void){
        
        return [RACSignal emailSignalWithEmail:@"1"];
        
    }];
    
    
    
    [signal flattenMap:^RACStream *(id value){
        
        RTLog(@"error %@",value);
        return value;
        
    }];
    
    
//    signal = [RACSignal signalWIthMobile:@"123" email:@"345" netSignal:[RACSignal empty]];
    
    
    [signal subscribeNext:^(id x){
        
        RTLog(@"next %@",x);
        
    } error:^(NSError *error){
        
        RTLog(@"error %@",error);
        
    } completed:^(void){
        
        RTLog(@"completed");
        
    }];

}


-(void)testCreateDefultData
{
    [CompanyModel createDefualtData];
}

-(void)testDynamicData
{
    NSMutableArray *models = [DynamicModel dynamicArrayWithPage:0];
    
    XCTAssertNotNil(models);
}

@end*/
