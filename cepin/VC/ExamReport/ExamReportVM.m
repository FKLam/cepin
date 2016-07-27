//
//  ExamReportVM.m
//  cepin
//
//  Created by dujincai on 15/6/9.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExamReportVM.h"
#import "RTNetworking+DynamicState.h"
#import "DynamicExamModelDTO.h"

@implementation ExamReportVM
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
    }
    if (self.isLoad) {
        self.load = [TBLoading new];
        [ self.load start];
        self.isLoad = NO;
    }
    RACSignal *signal = [[RTNetworking shareInstance] getMeExamReportWith:strUser tokenId:tokenId];
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
//                [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[DynamicExamModelDTO class]];
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
