//
//  SaveJobVM.m
//  cepin
//
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SaveJobVM.h"
#import "RTNetworking+Position.h"
#import "SaveJobDTO.h"
#import  "UserLoginDTO.h"
#import "CPRecommendModelFrame.h"

@implementation SaveJobVM

-(instancetype)init
{
    if (self = [super init])
    {
        self.isLoad = YES;
        self.selectJobs = [[NSMutableArray alloc]init];
        return self;
    }
    return nil;
}

-(void)loadDataWithPage:(NSInteger)page
{
    if (self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = NO;
    }
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    RACSignal *signal = [[RTNetworking shareInstance] getPositionCollectionListWithTokenId:strTokenId userId:strUser PageIndex:self.page PageSize:self.size];
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
           
            if (self.page==1 && !self.datas) {
                
//                [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[SaveJobDTO class]];
                [self.datas addObjectsFromArray:array];
                
            }else if(self.page>1 && self.datas){
                
//                [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[SaveJobDTO class]];
                [self.datas addObjectsFromArray:array];
            }else{
//                self.stateCode = [RTHUDModel hudWithCode:HUDCodeReflashSucess];
                 [self.datas removeAllObjects];
//                [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[SaveJobDTO class]];
                self.stateCode = [RTHUDModel hudWithCode:hudCodeUpdateSucess];
                [self.datas addObjectsFromArray:array];
            }
        }
        else
        {
            if (page==1) {
                [self.datas removeAllObjects];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }else{
                self.stateCode = [RTHUDModel hudWithCode:hudCodeUpdateSucess];
            }
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

        self.isLoad = YES;
    }
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
}
-(BOOL)selectedWithIndex:(NSInteger)index
{
    CPRecommendModelFrame *recommenModelFrame = self.datas[index];
    
    SaveJobDTO *model;
    
    if([recommenModelFrame.recommendModel isKindOfClass:[SaveJobDTO class]])
        model = (SaveJobDTO *)recommenModelFrame.recommendModel;
    
    for(NSDictionary *i in self.selectJobs)
    {
        SaveJobDTO *tmModel = [SaveJobDTO beanFromDictionary:i];
        if ([tmModel.PositionId isEqualToString:model.PositionId])
        {
            return YES;
        }
    }
    return NO;
}

-(void)deleteJobs
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    if (self.selectJobs.count > 0)
    {
        NSMutableArray *tmArray = [[NSMutableArray alloc]init];
        for (NSDictionary *item in self.selectJobs)
        {
            SaveJobDTO *tmModel = [SaveJobDTO beanFromDictionary:item];
            [tmArray addObject:tmModel.PositionId];
        }
        
        TBLoading *load = [TBLoading new];
        [load start];
        
        RACSignal *signal = [[RTNetworking shareInstance]positionBatchCancelCollectWithUserId:strUser positionIds:[tmArray componentsJoinedByString:@","]];
        @weakify(self);
        [signal subscribeNext:^(RACTuple *tuple){
            if (load)
            {
                [load stop];
            }
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)tuple.second;
            if ([dic resultSucess])
            {
                [OMGToast showWithText:@"删除成功" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                self.deleteJobStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
            else
            {
                if ([dic isMustAutoLogin])
                {
                    [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                }
                else
                {
                    [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                }
                
                //[OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            
        } error:^(NSError *error){
            if (load)
            {
                [load stop];
            }
            [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        }];
    }
    else
    {
        [OMGToast showWithText:@"您还未选择要删除的职位" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
    }
}

-(void)momeryRelease
{
    [self.datas removeAllObjects];
    self.datas = nil;
    [self.selectJobs removeAllObjects];
    self.selectJobs = nil;
}

@end
