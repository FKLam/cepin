//
//  TBUmengShareConfig.m
//  cepin
//
//  Created by zhu on 14/12/27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "TBUmengShareConfig.h"
#import "TBConfig.h"

#import "MobClick.h"
#import "UMSocialYixinHandler.h"
//#import "UMSocialFacebookHandler.h"

#import "UMSocialWechatHandler.h"
//#import "UMSocialTwitterHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"

#import "UMSocialInstagramHandler.h"
#import "UMSocialWhatsappHandler.h"
#import "UMSocialLineHandler.h"
#import "UMSocialTumblrHandler.h"
#import "UMFeedback.h"


@implementation TBUmengShareConfig

+ (void)initialize
{
#pragma mark - 屏蔽友盟分享成功时的提示
//    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    
}

+(void)configUmeng
{
    //反馈
    [UMFeedback setAppkey:UMENG_KEY];
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMENG_KEY];
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //使用友盟统计
    [MobClick startWithAppkey:UMENG_KEY];
    [MobClick checkUpdate];
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    //[UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx55ef761c672380a5" appSecret:@"76d3d501702a0bb8ad59a1d6bf239a5a" url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关
//    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialSinaHandler openSSOWithRedirectURL:@"https://openapi.baidu.com/social/oauth/2.0/receiver"];
    //打开腾讯微博SSO开关，设置回调地址，只支持32位
    //    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //打开人人网SSO开关，只支持32位
    //    [UMSocialRenrenHandler openSSO];
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接 //100427902  d9bcab3a3b9fda22fff1731ffe094730  100424468  c7394704798a158208a74ab60104f0ba
    //APP ID：		100424468
    //APP KEY：		c7394704798a158208a74ab60104f0ba
//    [UMSocialQQHandler setQQWithAppId:@"1101254984" appKey:@"d9bcab3a3b9fda22fff1731ffe094730" url:@"http://www.umeng.com/social"];
//        [UMSocialQQHandler setQQWithAppId:@"1101254984" appKey:@"TOHoykO0xE5tQCDk" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"100427902" appKey:@"d9bcab3a3b9fda22fff1731ffe094730" url:@"http://www.umeng.com/social"];
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //    //设置易信Appkey和分享url地址
    [UMSocialYixinHandler setYixinAppKey:@"yx35664bdff4db42c2b7be1e29390c1a06" url:@"http://www.umeng.com/social"];
    
    //    //设置来往AppId，appscret，显示来源名称和url地址，只支持32位
    //    [UMSocialLaiwangHandler setLaiwangAppId:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" appDescription:@"友盟社会化组件" urlStirng:@"http://www.umeng.com/social"];
    
    ////    设置facebook应用ID，和分享纯文字用到的url地址
//    [UMSocialFacebookHandler setFacebookAppID:@"91136964205" shareFacebookWithURL:@"http://www.umeng.com/social"];
    //
    ////    下面打开Instagram的开关
    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
    //
//    [UMSocialTwitterHandler openTwitter];
    
    //打开whatsapp
    [UMSocialWhatsappHandler openWhatsapp:UMSocialWhatsappMessageTypeImage];
    
    //打开Tumblr
    [UMSocialTumblrHandler openTumblr];
    
    //打开line
    [UMSocialLineHandler openLineShare:UMSocialLineMessageTypeImage];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
   }
+ (void)didSelectSocialPlatform:(NSString *)platformName vCtrl:(UIViewController*)vCtrl title:(NSString*)title content:(NSString*)content url:(NSString*)url imageUrl:(NSString*)imgUrl completion:(UMSocialDataServiceCompletion)completion
{
    if ([platformName isEqualToString:@"wxsession"])//微信
    {
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        if (imgUrl && ![imgUrl isEqualToString:@""] && ![@"http://hire.cepin.com" isEqualToString:imgUrl])
        {
            UIImage *tempImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            if ( !tempImage )
            {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:[UIImage imageNamed:@"cepin_icon_share"] location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                    completion(response);
                }];
            }
            else
            {
                UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                    imgUrl];
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:nil location:nil urlResource:urlResource presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                    completion(response);
                }];
            }
        }
        else
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:[UIImage imageNamed:@"cepin_icon_share"] location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                completion(response);
            }];
        }
    }
    if ([platformName isEqualToString:@"wxfriend"])//微信朋友圈
    {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        if (imgUrl && ![imgUrl isEqualToString:@""] && ![@"http://hire.cepin.com" isEqualToString:imgUrl])
        {
            UIImage *tempImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            if ( !tempImage )
            {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:[UIImage imageNamed:@"cepin_icon_share"] location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                    completion(response);
                }];
            }
            else
            {
                UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                    imgUrl];
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:nil location:nil urlResource:urlResource presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                    completion(response);
                }];
            }
        }
        else
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:[UIImage imageNamed:@"cepin_icon_share"] location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                completion(response);
            }];
        }
    }
    else if([platformName isEqualToString:@"qzone"])//qq空间
    {
        [UMSocialData defaultData].extConfig.qzoneData.url = url;
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
        
        if (imgUrl && ![imgUrl isEqualToString:@""] && ![@"http://hire.cepin.com" isEqualToString:imgUrl])
        {
            UIImage *tempImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            if ( !tempImage )
            {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:[UIImage imageNamed:@"cepin_icon_share"] location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                    completion(response);
                }];
            }
            else
            {
                UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
                
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:nil location:nil urlResource:urlResource presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                    completion(response);
                }];
            }
        }
        else
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:[UIImage imageNamed:@"cepin_icon_share"] location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                completion(response);
            }];
        }
    }
    else if([platformName isEqualToString:@"qq"])//qq
    {
        [UMSocialData defaultData].extConfig.qqData.url = url;
        [UMSocialData defaultData].extConfig.qqData.title = title;
        
        if (imgUrl && ![imgUrl isEqualToString:@""] && ![@"http://hire.cepin.com" isEqualToString:imgUrl])
        {
            UIImage *tempImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            if ( !tempImage )
            {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:[UIImage imageNamed:@"cepin_icon_share"] location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                    completion(response);
                }];
            }
            else
            {
                UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                    imgUrl];
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:nil location:nil urlResource:urlResource presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                    completion(response);
                }];
            }
        }
        else
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:[UIImage imageNamed:@"cepin_icon_share"] location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                completion(response);
            }];
        }
    }
    else if([platformName isEqualToString:@"sina"])//新浪微博
    {
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            nil];
        
        NSString *strFormat = [NSString stringWithFormat:@"%@\n%@",title,content];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:strFormat image:nil location:nil urlResource:urlResource presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
            completion(response);
        }];
    }
    else if([platformName isEqualToString:@"tencent"])//腾讯微博
    {
        //[UMSocialData defaultData].extConfig.tencentData.url = url;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            nil];
        NSString *strFormat = [NSString stringWithFormat:@"%@\n%@",title,content];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToTencent] content:strFormat image:nil location:nil urlResource:urlResource presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
            completion(response);
        }];
    }
    else if([platformName isEqualToString:@"renren"])//人人
    {
        [UMSocialData defaultData].extConfig.renrenData.url = url;
        NSString *strFormat = [NSString stringWithFormat:@"%@\n%@",title,content];
    
        if (imgUrl && ![imgUrl isEqualToString:@""]&& ![@"http://hire.cepin.com" isEqualToString:imgUrl])
        {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                imgUrl];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToRenren] content:strFormat image:nil location:nil urlResource:urlResource presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                completion(response);
            }];
        }
        else
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToRenren] content:content image:[UIImage imageNamed:@"cepin_icon_share"] location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
                completion(response);
            }];
        }
    }
    else if([platformName isEqualToString:@"sms"])//短信
    {
        NSString *strFormat = [NSString stringWithFormat:@"%@\n%@",title,content];
        strFormat = [NSString stringWithFormat:@"%@\n%@",strFormat,url];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:strFormat image:nil location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
            completion(response);
        }];
    }
    else if([platformName isEqualToString:@"email"])//邮件
    {
        NSString *strFormat = [NSString stringWithFormat:@"%@\n%@",title,content];
        strFormat = [NSString stringWithFormat:@"%@\n%@",strFormat,url];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:strFormat image:nil location:nil urlResource:nil presentedController:vCtrl completion:^(UMSocialResponseEntity *response){
            completion(response);
        }];
    }
}

@end
