//
//  JobFilterModel.m
//  cepin
//
//  Created by Ricky Tang on 14-11-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobFilterModel.h"
#import "FileManagerHelper.h"

static NSString *JobFilterData = @"JobFilterData";

@implementation JobFilterModel

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static JobFilterModel *instance;
    dispatch_once(&onceToken, ^{
        instance = [JobFilterModel loadData];
    });
    
    return instance;
}

+(instancetype)loadData
{
    NSString *jsonString = [[NSString alloc] initWithData:[FileManagerHelper readDataWithFolder:nil andFile:JobFilterData andSandBoxFolder:kUseDocumentTypeLibraryCaches] encoding:NSUTF8StringEncoding];
    JobFilterModel *model = [[JobFilterModel alloc] initWithString:jsonString error:nil];
    
    if (!model) {
        return [[JobFilterModel alloc] init];
    }
    return model;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.addresses = (NSMutableArray<Region> *)[[NSMutableArray alloc] initWithCapacity:3];
        self.salary = [BaseCode new];
        self.jobProperty = [BaseCode new];
        self.WorkYears = [BaseCode new];
    }
    return self;
}


-(BOOL)saveObjectToDisk
{
    NSString *jsonString = [self toJSONString];
    return [FileManagerHelper writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] withFile:JobFilterData andFolder:nil andSandBoxFolder:kUseDocumentTypeLibraryCaches];
}

-(BOOL)deleteObjectFromDisk
{
    [self.addresses removeAllObjects];
    self.jobProperty = [BaseCode new];
    self.salary = [BaseCode new];
    self.WorkYears = [BaseCode new];
   return  [FileManagerHelper deleteObjectWithFile:JobFilterData folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
}

-(void)reset
{
    NSString *jsonString = [[NSString alloc] initWithData:[FileManagerHelper readDataWithFolder:nil andFile:JobFilterData andSandBoxFolder:kUseDocumentTypeLibraryCaches] encoding:NSUTF8StringEncoding];
    JobFilterModel *model = [[JobFilterModel alloc] initWithString:jsonString error:nil];
    if (!model)
    {
        model = [JobFilterModel new];
    }
    
    self.jobProperty = model.jobProperty;
    self.salary = model.salary;
    self.keyWord = model.keyWord;
    self.WorkYears = model.WorkYears;
    self.addresses = model.addresses;
}

@end
