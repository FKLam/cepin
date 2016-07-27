//
//  TBShare.m
//  cepin
//
//  Created by tassel.li on 14-5-22.
//  Copyright (c) 2014年 tassel.li. All rights reserved.
//

#import "TBShare.h"
@implementation TBShare

+(void)ConfigurationShare
{
    [Frontia initWithApiKey:BAIDUSHARE_KEY];
    FrontiaShare *share = [Frontia getShare];
    [share registerSinaweiboAppId:SINA_APP_KEY];
    [share registerWeixinAppId:WEIXIN_APP_KEY];
    [share registerQQAppId:TENCENT_APP_KEY enableSSO:YES];
    

}
+(void)ShowShareMenu:(NSDictionary *)paramsDic completed:(ShareCompletedBlock )completeBlock failed:(ShareFairedBlock)failedBlock cancel:(ShareCancelBlock)cancelBlock
{

    FrontiaShareContent *content = [[FrontiaShareContent alloc] init];
    content.url =paramsDic[@"url"];
    content.title=paramsDic[@"title"];
    content.description = paramsDic[@"description"];
    content.imageObj =paramsDic[@"imageObj"];

    NSArray * platforms = [NSArray arrayWithObjects:FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_QQFRIEND,FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL,FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE,FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,FRONTIA_SOCIAL_SHARE_PLATFORM_SMS,nil];
    
    FrontiaShare *share = [Frontia getShare];
    
    [share showShareMenuWithShareContent:content displayPlatforms:platforms supportedInterfaceOrientations:UIInterfaceOrientationMaskAllButUpsideDown isStatusBarHidden:NO targetViewForPad:nil cancelListener:^{
        //NSLog(@"OnCancel: share is cancelled");
        cancelBlock();
        
    } failureListener:^(int errorCode, NSString *errorMessage) {
        //NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
        failedBlock(errorCode,errorMessage);
        
    } resultListener:^(NSDictionary *respones) {
        
        completeBlock(respones);
        //NSArray *successPlatforms = [respones objectForKey:@"success"];
        //NSArray *failPlatforms = [respones objectForKey:@"fail"];
    }];



}
+(void)ThirdPartLogin:(NSString *)platform completed:(LoginCompletedBlock )completeBlock failed:(LoginFairedBlock )failedBlock cancel:(LoginCancelBlock)cancelBlock
{


    FrontiaAuthorization* authorization = [Frontia getAuthorization];
    
    //授权取消回调函数
    FrontiaAuthorizationCancelCallback onCancel = ^(){
        cancelBlock();
//        CepinLog(@"OnCancel: authorization is cancelled");
    };
    
    //授权失败回调函数
    FrontiaAuthorizationFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
        failedBlock(errorCode,errorMessage);
        RTLog(@"OnFailure: %d  %@", errorCode, errorMessage);
    };
    
    //授权成功回调函数
    FrontiaAuthorizationResultCallback onResult = ^(FrontiaUser *result){
        RTLog(@"OnResult: %@", result.accountName);
        // accessToken = result.accessToken;
        completeBlock(result);
        //设置授权成功的账户为当前使用者账户
        [Frontia setCurrentAccount:result];
    };
    
    
    NSArray *scope = @[@"basic", @"netdisk", @"pcs_video"];//设置授权权限
    [authorization authorizeWithPlatform:platform scope:scope supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO cancelListener:onCancel failureListener:onFailure resultListener:onResult];


}


+(void)clearAllAuthorization
{


    
    FrontiaAuthorization* authorization = [Frontia getAuthorization];
    [authorization clearAllAuthorizationInfo];

}


@end
