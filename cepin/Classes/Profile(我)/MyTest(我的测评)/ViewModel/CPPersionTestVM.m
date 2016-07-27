//
//  CPPersionTestVM.m
//  cepin
//
//  Created by ceping on 16/1/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPersionTestVM.h"
#import "RTNetworking+DynamicState.h"

@implementation CPPersionTestVM
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
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString*tokenId = [[MemoryCacheData shareInstance] userTokenId];
    if (!strUser)
    {
        strUser = @"";
        tokenId = @"";
    }
    if (self.isLoad) {
        self.load = [TBLoading new];
        [ self.load start];
        self.isLoad = NO;
    }
    RACSignal *signal = [[RTNetworking shareInstance] getPersonExamListWith:strUser tokenId:tokenId];
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
                [self.datas addObjectsFromArray:array];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
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
    if (self.load) {
        [self.load stop];
    }
    self.isLoad = YES;
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
}
@end
