//
//  SaveCompanyVM.m
//  cepin
//
//  Created by Ricky Tang on 14-11-4.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SaveCompanyVM.h"
#import "RTNetworking+Company.h"
#import "SaveCompanyModel.h"
#import "CPRecommendModelFrame.h"

@implementation SaveCompanyVM

-(instancetype)init
{
    if (self = [super init])
    {
        self.selectedCompanies = [[NSMutableArray alloc]init];
        self.isLoad = NO;
    }
    return self;
}

-(void)loadDataWithPage:(NSInteger)page
{
    if (self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
    }
    
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];

    RACSignal *signal = [[RTNetworking shareInstance]getCompanyFocusListWithTokenId:strTokenId userId:strUser PageIndex:self.page PageSize:self.size];
    
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
   
        if (self.load) {
            [self.load stop];
        }
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.stateCode = [RTHUDModel hudWithCode:hudCodeUpdateSucess];
            NSArray *array = [dic resultObject];
            if (self.page==1 && !self.datas) {
//                [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[SaveCompanyModel class]];
                [self.datas addObject:array];
            }else if(self.page>1 && self.datas){
//                [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[SaveCompanyModel class]];
                [self.datas addObject:array];
            }else{
                [self.datas removeAllObjects];
//                [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[SaveCompanyModel class]];
                [self.datas addObject:array];
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
//            [self.datas removeAllObjects];
//            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
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

-(void)momeryRelease
{
    [self.datas removeAllObjects];
    self.datas = nil;
    [self.selectedCompanies removeAllObjects];
    self.selectedCompanies = nil;
}

-(BOOL)selectedWithIndex:(NSInteger)index
{
    CPRecommendModelFrame *recommendModelFrame = self.datas[index];
    
    SaveCompanyModel *model;
    
    if( [recommendModelFrame.recommendModel isKindOfClass:[SaveCompanyModel class]] )
        model = (SaveCompanyModel *)recommendModelFrame.recommendModel;
    
    for(NSDictionary *i in self.selectedCompanies)
    {
        SaveCompanyModel *tmModel = [SaveCompanyModel beanFromDictionary:i];
        if ([tmModel.CustomerId isEqualToString:model.CustomerId])
        {
            return YES;
        }
    }
    return NO;
}

-(void)cancelSavecompany
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];

    if (self.selectedCompanies.count > 0)
    {
        NSMutableArray *tmArray = [[NSMutableArray alloc]init];
        SaveCompanyModel *tmModel = nil;
        for (CPRecommendModelFrame *item in self.selectedCompanies)
        {
            if ( ![item.recommendModel isKindOfClass:[SaveCompanyModel class]] )
                continue;
            
            tmModel = (SaveCompanyModel *)item.recommendModel;
            
            [tmArray addObject:tmModel.CustomerId];
        }
        
        TBLoading *load = [TBLoading new];
        [load start];
        
        RACSignal *signal = [[RTNetworking shareInstance]companyBatchCancelCollectWithCustomerIds:[tmArray componentsJoinedByString:@","] UserId:strUser];
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
                self.deleteSaveCompany = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
            else
            {
                if ([dic isMustAutoLogin])
                {
                    [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                }
                else
                {
//                    [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
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
        [OMGToast showWithText:@"您还未选择要删除的企业" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
    }
}



@end
