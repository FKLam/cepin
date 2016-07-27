//
//  SaveVM.m
//  cepin
//
//  Created by dujincai on 15/6/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SaveVM.h"
#import "RTNetworking+Position.h"
#import "RTNetworking+Company.h"
#import "CPRecommendModelFrame.h"

@implementation SaveVM
-(instancetype)init
{
    if (self = [super init])
    {
        self.selectJobs = [[NSMutableArray alloc]init];
        self.selectedCompanies = [[NSMutableArray alloc]init];
        return self;
    }
    return nil;
}

-(void)deleteJobs
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    if (self.selectJobs.count > 0)
    {
        NSMutableArray *tmArray = [[NSMutableArray alloc]init];
        
        SaveJobDTO *tmModel = nil;
    
        for (CPRecommendModelFrame *item in self.selectJobs)
        {
            if (![item.recommendModel isKindOfClass:[SaveJobDTO class]])
                continue;
            
            tmModel = (SaveJobDTO *)item.recommendModel;
            
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
                [OMGToast showWithText:@"删除成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
                self.deleteJobStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
            else
            {
                
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


-(void)cancelSavecompany
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    
    if (self.selectedCompanies.count > 0)
    {
        NSMutableArray *tmArray = [[NSMutableArray alloc]init];
        
        SaveCompanyModel *tmModel = nil;
        
        for (CPRecommendModelFrame *item in self.selectedCompanies)
        {
            if (![item.recommendModel isKindOfClass:[SaveCompanyModel class]])
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
                [OMGToast showWithText:@"删除成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
                self.deleteSaveCompany = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
            else
            {
               
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
