//
//  TheCompanyJobVM.m
//  cepin
//
//  Created by zhu on 14/12/21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "TheCompanyJobVM.h"
#import "RTNetworking+Company.h"
#import "JobSearchModel.h"

@implementation TheCompanyJobVM

-(instancetype)initWithCompanyId:(NSString*)companyId
{
    if (self = [super init])
    {
        self.isLoad = YES;
        self.theCompanyId = companyId;
        return self;
    }
    return nil;
}

- (void)allPositionId
{
    self.positionIdArray = [PositionIdModel allPositionIds];
}

-(void)momeryRelease
{
    [self.datas removeAllObjects];
    self.datas = nil;
    self.theCompanyId = nil;
}

-(void)loadDataWithPage:(NSInteger)page
{
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTokenId = @"";
    }
    
   
   
    if (self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = NO;
    }
 
    RACSignal *signal = [[RTNetworking shareInstance]getCompanyPositionListWithTokenId:strTokenId userId:strUser customerId:self.theCompanyId PageIndex:self.page PageSize:self.size];
    
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
#pragma waring - 待处理。。。
            [self dealDataAndStateCodeWithPage:self.page bean:array modelClass:[JobSearchModel class]];
            self.showDone = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
            }
            else
            {
                // LFK禁止弹出企业没有更多职位的提示
//                [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
            }
            
//            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            
            
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        }
        
        
    } error:^(NSError *error){
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
        RTLog(@"%@",[error description]);
     
    }];
}

- (void)stop
{
    if (self.load)
    {
        [self.load stop];
    }
    self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
}

@end
