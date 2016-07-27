//
//  TBTabViewModel.m
//  cepin
//
//  Created by dujincai on 15/9/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "TBTabViewModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "RTNetworking+Position.h"
@implementation TBTabViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)checkVersion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:@"http://itunes.apple.com/lookup?id=894486180" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        RTLog(@"%@",responseObject);
        
        NSArray *infoArray = [responseObject objectForKey:@"results"];
        
        NSDictionary *dic = [infoArray objectAtIndex:0];
        self.version = [dic objectForKey:@"version"];
        self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//判断是否做过测聘
- (void)checkHasCepin
{
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if (!strUser)
    {
//        strUser = @"";
//        strTocken = @"";
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance]isExamWithTokenId:strTocken userId:strUser];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
       
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            self.isExam = [[[dic resultObject]objectForKey:@"IsFinshed"] boolValue];
            
            self.isExamStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            self.isExamStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } error:^(NSError *error){
        self.isExamStateCode = error;
        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout ];
    }];
    
}
@end
