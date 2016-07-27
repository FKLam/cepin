//
//  JobSearchVM.m
//  cepin
//
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobSearchVM.h"
#import "RTNetworking+Position.h"
#import "BookingJobFilterModel.h"
#import "TBTextUnit.h"
#import "JobSearchModel.h"

@implementation JobSearchVM
-(instancetype)init
{
    if (self = [super init])
    {
      
        self.subModel = [SubscriptionJobModel new];
        self.keywords = [KeywordModel allKeywords];
        self.isLoad = YES;
        NSString *strUser = [[MemoryCacheData shareInstance]userId];
        if (!strUser)
        {
            strUser = @"";
        }
        [[BookingJobFilterModel shareInstance]reloadWithFileName:strUser];
        self.size = 10;
    }
    return self;
}

- (void)allPositionId
{
    self.positionIdArray = [PositionIdModel allPositionIds];
}

-(void)deleteAllKeywords
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    if (!strUser)
    {
        strUser = @"";
    }
    [KeywordModel deleteWithWhere:[NSString stringWithFormat:@"userID = \"%@\"", strUser]];
    
    [self.keywords removeAllObjects];
}
-(void)deleteKeyWord:(NSString*)keyword
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    if (!strUser)
    {
        strUser = @"";
    }
    if (strUser)
    {
        [KeywordModel deleteWithWhere:[NSString stringWithFormat:@"userID = \"%@\" and keyword = \"%@\"", strUser,keyword]];
    }else{
        [KeywordModel deleteWithWhere:[NSString stringWithFormat:@"userID = \"%@\" and keyword = \"%@\"", strUser,keyword]];
    }
    [self.keywords removeObject:keyword];
}
- (void)sort
{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc]initWithKey:@"createDate" ascending:NO];
    NSMutableArray   *sortDescriptors = [[NSMutableArray alloc]initWithObjects:&sorter count:1];
    NSArray          *sortArray = [self.keywords sortedArrayUsingDescriptors:sortDescriptors];
    
    [self.keywords removeAllObjects];
    [self.keywords addObjectsFromArray:sortArray];
}

-(void)loadDataWithPage:(NSInteger)page
{
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;

    if (!strUser || [strUser length] == 0)
    {
        strUser = @"";
        strTocken = @"";
    }
   
    if (self.isLoad) {
       self.load = [TBLoading new];
        [self.load start];
        self.isLoad = NO;
    }
    
    if (!self.subModel.positionTypekey || [@"" isEqualToString:self.subModel.positionTypekey]) {
        self.subModel.positionTypekey = @"";
    }
    
    
    if (!self.subModel.Degree ) {
        self.subModel.Degree = @"";
    }
    
    if(self.subModel.salary && [self.subModel.salary isEqualToString:@"25K以上"]){
        self.self.subModel.salary = @"25K以上";
        self.subModel.salarykey = @"25K-100K";
    }
    
    
    if(self.subModel.workYearkey && ![@"" isEqualToString:self.subModel.workYearkey] ){
        NSArray *array = [self.subModel.workYearkey componentsSeparatedByString:@"~"];
        if(array.count>1){
            self.subModel.workYearMin = array[0];
            self.subModel.workYearMax = array[1];
        }else{
            self.subModel.workYearMin = self.subModel.workYearkey;
            self.subModel.workYearMax = self.subModel.workYearkey;
        }
    }else{
        self.subModel.workYearMin = @"";
        self.subModel.workYearMax = @"";
    }
    
    RACSignal *signal = [[RTNetworking shareInstance]getPositionSeachWithPageIndex:self.page PageSize:self.size JobFunction:self.subModel.jobFunctionskey city:self.subModel.addresskey EmployType:self.subModel.jobPropertyskey Salary:self.subModel.salarykey WorkYear:self.subModel.workYearkey SearchKey:self.keyword PositonType:[NSString stringWithFormat:@"%@",self.subModel.positionTypekey] WorkYearMin:self.subModel.workYearMin  WorkYearMax:self.subModel.workYearMax Degree:self.subModel.Degree];
    
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        if (self.load)
        {
            [self.load stop];
        }
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            RTLog(@"%@",array);
            if (array)
            {
                if (self.page == 1)
                {
                    [self.datas removeAllObjects];
                }
#pragma waring - 待处理。。。
                [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[JobSearchModel class]];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
        }
        else
        {
            if (self.page == 1)
            {
                [self.datas removeAllObjects];
            }
            
//            [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:0 duration:0];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];

        }
        
    } error:^(NSError *error){
        
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
        RTLog(@"%@",[error description]);
    }];
}

- (void)stop
{
    if (self.load) {
        [self.load stop];
    }
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
    self.isLoad = YES;
}
@end
