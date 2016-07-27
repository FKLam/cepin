//
//  DynamicExamVM.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicExamVM.h"
#import "RTNetworking+DynamicState.h"
#import "DynamicExamModelDTO.h"

@implementation DynamicExamVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLoad = YES;
    }
    return self;
}
-(void)loadDataWithPage:(NSInteger)page
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTocken = [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTocken = @"";
    }
    self.load = nil;
    if (self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = NO;
    }
    
    RACSignal *signal = [[RTNetworking shareInstance]getDynamicStateExamListWithUUID:UUID_KEY tokenId:strTocken userId:strUser PageIndex:self.page PageSize:self.size examStatus:@"1"];
    
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
#pragma warning - 待处理。。。
               [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[DynamicExamModelDTO class]];
            }
        }
        else
        {
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error){
        @strongify(self);
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
       
        
        RTLog(@"%@",[error description]);
    }];
}
-(void)stop
{
    if (self.load) {
        [self.load stop];
    }
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
    self.isLoad = YES;
}
@end


