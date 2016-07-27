//
//  CPJobRecommendVM.m
//  cepin
//
//  Created by dujincai on 16/3/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPJobRecommendVM.h"
#import "RTNetworking+Position.h"
#import "CPJobRecommendModel.h"

@implementation CPJobRecommendVM

-(instancetype)init
{
    if (self = [super init]) {
        self.isLoad = YES;
        self.size = 10;
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
    RACSignal *signal = [[RTNetworking shareInstance] getJobRecommendWithTokenId:strTocken userId:strUser pageSize:self.size pageIndex:self.page];
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
            if (array)
            {
                int i = 0;
                NSInteger size = [array count];
                for(;i<size;i++){
                    CPJobRecommendModel *model = [CPJobRecommendModel beanFromDictionary:array[i]];
                    [self.datas addObject:model];
                }
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
