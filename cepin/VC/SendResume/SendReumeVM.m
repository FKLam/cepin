//
//  SendReumeVM.m
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SendReumeVM.h"
#import "RTNetworking+Resume.h"
#import "SendReumeModel.h"


@implementation SendReumeVM


-(instancetype)init
{
    if (self = [super init]) {
        self.isLoad = YES;
    }
    return self;
}

-(void)loadDataWithPage:(NSInteger)page
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString *strTocken = [[MemoryCacheData shareInstance] userTokenId];
    if(!strUser){
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance]getResumeDeliveriedListWithTokenId:strTocken userId:strUser PageIndex:self.page PageSize:10];
    
    
    if (self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = NO;
    }
    
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
                [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[SendReumeModel class]];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeReflashSucess];
            }
            else
            {
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
        }
        else
        {
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        }
        
    } error:^(NSError *error){
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
        
    }];
}

- (void)stop
{
 
    if (self.load)
    {
        [self.load stop];
    }
    self.isLoad = YES;
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];

}

@end
