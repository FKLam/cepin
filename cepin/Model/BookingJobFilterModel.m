//
//  BookingJobFilterModel.m
//  cepin
//
//  Created by Ricky Tang on 14-11-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BookingJobFilterModel.h"
#import "FileManagerHelper.h"
#import "UserLoginDTO.h"

static NSString *BookingJobFilterData = @"BookingJobFilterData.json";
static NSString *BookingJobFilterNoUserData = @"BookingJobFilterNoUserData.json";

@implementation BookingJobFilterModel

+(instancetype)shareInstance
{
    static BookingJobFilterModel *instance;
    @synchronized(self){
        if (!instance)
        {
            instance = [BookingJobFilterModel new];
        }
        return instance;
    }
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.industries = (NSMutableArray<BaseCode> *)[NSMutableArray arrayWithCapacity:3];
        self.jobFunctions = (NSMutableArray<BaseCode> *)[NSMutableArray arrayWithCapacity:3];
        self.companyNature = (NSMutableArray<BaseCode> *)[NSMutableArray arrayWithCapacity:3];
        self.companySize = (NSMutableArray<BaseCode> *)[NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

-(void)reloadWithFileName:(NSString*)fieName
{
    BookingJobFilterModel *model;
    if ([fieName isEqualToString:@""])
    {
        NSString *jsonString = [[NSString alloc] initWithData:[FileManagerHelper readDataWithFolder:nil andFile:BookingJobFilterNoUserData andSandBoxFolder:kUseDocumentTypeLibraryCaches] encoding:NSUTF8StringEncoding];
        model = [[BookingJobFilterModel alloc] initWithString:jsonString error:nil];
    }
    else
    {
        NSString *saveFileName = [NSString stringWithFormat:@"%@.json",[MemoryCacheData shareInstance].userLoginData.UserId];
        NSString *jsonString = [[NSString alloc] initWithData:[FileManagerHelper readDataWithFolder:nil andFile:saveFileName andSandBoxFolder:kUseDocumentTypeLibraryCaches] encoding:NSUTF8StringEncoding];
        
        //NSString *jsonString = [[NSString alloc] initWithData:[FileManagerHelper readDataWithFolder:nil andFile:BookingJobFilterData andSandBoxFolder:kUseDocumentTypeLibraryCaches] encoding:NSUTF8StringEncoding];
        model = [[BookingJobFilterModel alloc] initWithString:jsonString error:nil];
    }
    if (model)
    {
        self.addresses = model.addresses;
        self.jobProperty = model.jobProperty;
        self.salary = model.salary;
        self.industries = model.industries;
        self.jobFunctions = model.jobFunctions;
        self.companyNature = model.companyNature;
        self.companySize = model.companySize;
        [self checkValid];
    }
    else
    {
        [self clear];
    }
}

-(BOOL)saveObjectToDiskWithFile:(NSString*)fieName
{
    NSString *jsonString = [[BookingJobFilterModel shareInstance] toJSONString];
    
    if ([fieName isEqualToString:@""])
    {
        return [FileManagerHelper writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] withFile:BookingJobFilterNoUserData andFolder:nil andSandBoxFolder:kUseDocumentTypeLibraryCaches];
    }
    
    NSString *saveFileName = [NSString stringWithFormat:@"%@.json",[MemoryCacheData shareInstance].userLoginData.UserId];
    return [FileManagerHelper writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] withFile:saveFileName andFolder:nil andSandBoxFolder:kUseDocumentTypeLibraryCaches];
    
    //return [FileManagerHelper writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] withFile:BookingJobFilterData andFolder:nil andSandBoxFolder:kUseDocumentTypeLibraryCaches];
    
    return YES;
}

-(BOOL)deleteObjectFromDisk:(NSString*)fileName
{
    [self clear];
    if ([fileName isEqualToString:@""])
    {
        return  [FileManagerHelper deleteObjectWithFile:BookingJobFilterNoUserData folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    }
    
    NSString *saveFileName = [NSString stringWithFormat:@"%@.json",[MemoryCacheData shareInstance].userLoginData.UserId];
    return  [FileManagerHelper deleteObjectWithFile:saveFileName folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    //return  [FileManagerHelper deleteObjectWithFile:BookingJobFilterData folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
}

-(void)deleteObjectFromNet:(NSString*)fileName
{
    [self deleteObjectFromDisk:fileName];
}

-(void)deleteJobSearch:(NSString*)fileName
{
    [self.addresses removeAllObjects];
    self.salary = [BaseCode new];
    self.jobProperty = [BaseCode new];
    [self saveObjectToDiskWithFile:fileName];
}

-(void)resetWithModelAndFileName:(SubscriptionJobModelDTO*)bean file:(NSString*)fileName
{
    self.jobProperty = [BaseCode employTypeWithCode:bean.jobPropertys];
    if (bean.salary)
    {
        NSString *str = nil;
        if ([bean.salary isEqualToString:@"100"] || [bean.salary isEqualToString:@"min100"])
        {
            str = @"min100";
        }
        else if ([bean.salary isEqualToString:@"150"] || [bean.salary isEqualToString:@"min150"])
        {
            str = @"min150";
//            self.salary = [BaseCode salaryWithCodeAndEmployType:str type:bean.jobPropertys];
        }
        self.salary = [BaseCode salaryWithCodeAndEmployType:str type:bean.jobPropertys];
    }

    self.addresses = (NSMutableArray<Region>*)[Region searchAddressWithAddressPathCodeString:bean.address];
    self.jobFunctions = (NSMutableArray<BaseCode>*)[BaseCode baseCodeWithCodeKeys:bean.jobFunctions];
    self.industries = (NSMutableArray<BaseCode>*)[BaseCode baseCodeWithCodeKeys:bean.industries];
    self.companyNature = (NSMutableArray<BaseCode>*)[BaseCode baseCodeWithCodeKeys:bean.companyNature];
    self.companySize = (NSMutableArray<BaseCode>*)[BaseCode baseCodeWithCodeKeys:bean.companySize];
    
    [self checkValid];
    [self saveObjectToDiskWithFile:fileName];
}

-(void)clear
{
    [self.addresses removeAllObjects];
    self.jobProperty = [BaseCode new];
    self.salary = [BaseCode new];
    [self.industries removeAllObjects];
    [self.jobFunctions removeAllObjects];
    [self.companyNature removeAllObjects];
    [self.companySize removeAllObjects];
    
}

-(void)checkValid
{
    if (!self.addresses)
    {
        self.addresses = [(NSMutableArray<Region>*)[NSMutableArray alloc]init];
    }
    
    if (!self.jobFunctions)
    {
        self.jobFunctions = [(NSMutableArray<BaseCode>*)[NSMutableArray alloc]init];
    }
    
    if (!self.industries)
    {
        self.industries = [(NSMutableArray<BaseCode>*)[NSMutableArray alloc]init];
    }
    
    if (!self.companyNature)
    {
        self.companyNature = [(NSMutableArray<BaseCode>*)[NSMutableArray alloc]init];
    }
    if (!self.companySize)
    {
        self.companySize = [(NSMutableArray<BaseCode>*)[NSMutableArray alloc]init];
    }
    if (!self.jobProperty)
    {
        self.jobProperty = [BaseCode new];
    }
    if (!self.salary)
    {
        self.salary = [BaseCode new];
    }
}

@end
