//
//  CPWatchResumeVM.m
//  cepin
//
//  Created by dujincai on 16/3/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWatchResumeVM.h"
#import "RTNetworking+Company.h"
#import "CPJobRecommendModel.h"

@implementation CPWatchResumeVM
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
    
    RACSignal *signal = [[RTNetworking shareInstance]getViewedResumeListWithTokenId:strTocken userId:strUser resumeId:self.resumeId PageIndex:self.page PageSize:self.size];
    
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
//            RTLog(@"%@",array);
            if (array)
            {
                [self.datas addObjectsFromArray:array];
                self.stateCode = [RTHUDModel hudWithCode:hudCodeUpdateSucess];
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
