//
//  AddResumeTagVM.m
//  cepin
//
//  Created by dujincai on 15/6/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddResumeTagVM.h"
#import "RTNetworking+Resume.h"
#import "TBTextUnit.h"
#import "NSString+WeiResume.h"

@implementation AddResumeTagVM

- (instancetype)initWithResumeModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.resumeModel = model;
        self.tagArray = [NSMutableArray new];
        if (self.resumeModel.Keywords.length>0) {
            NSArray *array = [self.resumeModel.Keywords componentsSeparatedByString:@","];
            [self.tagArray addObjectsFromArray:array];
        }
      
    }
    return self;
}

- (void)addResumeTag
{
    TBLoading *load = [TBLoading new];
    [load start];
    
    NSString *str = [TBTextUnit configWithTag:self.tagArray];
    
    if (str.length <= 0 || [str isEqualToString:@""]) {
         [OMGToast showWithText:@"关键字不能为空" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        [load stop];
        return;
    }
    

    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    
    RACSignal *signal = [[RTNetworking shareInstance]addThridResumeKeyWordWithResumeId:self.resumeModel.ResumeId userId:userId tokenId:TokenId keyWords:str];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
                [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
            }
        }
        
    } error:^(NSError *error){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        self.stateCode = [NSError errorWithErrorMessage:NetWorkError];
    }];
}
@end
