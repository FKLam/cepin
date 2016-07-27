//
//  RTWeiXinHelper.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-16.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "RTWeiXinHelper.h"
#import "NSJSONSerialization+RTAddition.h"
#import "NSJSONSerialization+RTAddition.h"
#import "NSObject+ObjectMap.h"
#import "RTAlipayHelp.h"
#import "StoreHomeViewController.h"
#import "InviteModel.h"
#import "MineInviteViewController.h"
#import "NSDate-Utilities.h"


static RTWeiXinHelper *instanceOfWeiXinHelper;
NSString *const SocialTypeName = @"type";
NSString *const SocialTypeStoreId = @"storeId";
NSString *const SocialTypeTrade = @"trade";
NSString *const SocialTypeBookingDinner = @"bookingDinner";
NSString *const SocialTypeBookingTable = @"bookingTable";
NSString *const SocialTypeStoreWrap = @"storeWrap";

#define BUFFER_SIZE 1024 * 100

@interface RTWeiXinHelper ()
@property(nonatomic,strong)id<RTAlipayHelpDelegate> delegate;
@end


@implementation RTWeiXinHelper


+(id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceOfWeiXinHelper = self.new;
    });
    return instanceOfWeiXinHelper;
}

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    [[(UINavigationController *)ROOTVIEWCONTROLLER.presentedViewController topViewController] dismissViewControllerAnimated:NO completion:nil];
    
    if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        RTLog(@"wx request %@",req);
        
        //接受从微信发来的页面展示请求，根据数据的不同展示不同的页面。指app内部信息通过微信传递
        ShowMessageFromWXReq *sReq = (ShowMessageFromWXReq *)req;
        //NSData *data = [[(WXAppExtendObject *)sReq.message.mediaObject extInfo] dataUsingEncoding:NSUTF8StringEncoding];
        RTLog(@"extInfo string %@",[(WXAppExtendObject *)sReq.message.mediaObject extInfo]);
        NSDictionary *dic = [NSJSONSerialization convertToObjectWithJsonString:[(WXAppExtendObject *)sReq.message.mediaObject extInfo]];
        RTLog(@"request dic %@",dic);
        switch ([[dic objectForKey:SocialTypeName] integerValue]) {
            case SocialTypeStore:
            {
                StoreHomeViewController *vc = [[StoreHomeViewController alloc] initWithStoreId:[dic objectForKey:SocialTypeStoreId]];
                BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                
                [[RTAppHelper shareInstance] setCurrentRoadPath:RoadPathTypeWX];
                
                vc.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWithBlock:^(id sender){
                    [vc dismissViewControllerAnimated:YES completion:^(void){
                        [[RTAppHelper shareInstance] setCurrentRoadPath:RoadPathTypeNormal];
                    }];
                }];
                [ROOTVIEWCONTROLLER  presentViewController:navi animated:NO completion:nil];
            }
                break;
            case SocialTypeBooking:
            {
                NSError *error = nil;
                
//                NSString *temp = [dic objectForKey:SocialTypeTrade];
//                NSDictionary *tradeDic = [NSJSONSerialization convertToObjectWithJsonString:temp];
                
                TradeNewDTO *trade = [[TradeNewDTO alloc] initWithString:[dic objectForKey:SocialTypeTrade] error:&error];
                
                RTLog(@"error for trade encode %@",error);
                
                NSAssert(!error, @"error");
                
                InviteModel *model = [[InviteModel alloc] initWithTrade:trade];
                [model save];
                
                MineInviteViewController *vc = [[MineInviteViewController alloc] initWithModel:model];
                BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                
                [[RTAppHelper shareInstance] setCurrentRoadPath:RoadPathTypeWX];
                
                vc.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWithBlock:^(id sender){
                    [vc dismissViewControllerAnimated:YES completion:^(void){
                        [[RTAppHelper shareInstance] setCurrentRoadPath:RoadPathTypeNormal];
                    }];
                }];
                [ROOTVIEWCONTROLLER  presentViewController:navi animated:NO completion:nil];
            }
                break;
                
            default:
                break;
        }
        
    }
    else if ([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        //接受从微信发送来的数据请求,
        RTLog(@"GetMessageFromWXReq");
        //去到收藏的列表
//        WXStoreShareViewController *vc = [WXStoreShareViewController new];
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//        [ROOTVIEWCONTROLLER  presentViewController:navi animated:NO completion:nil];
        
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //微信启动启动应用时
        RTLog(@"LaunchFromWXReq");
    }
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */

-(void) onResp:(BaseResp*)resp
{
    [[(UINavigationController *)ROOTVIEWCONTROLLER.presentedViewController topViewController] dismissViewControllerAnimated:NO completion:nil];
    RTLog(@"SendMessage Resp");
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //向微信发送信息后的回调
        RTLog(@"SendMessageToWXResp err %@ ; code %d",resp.errStr,resp.errCode);
    }
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didPaySucessWithResult:)] ) {
                    [self.delegate didPaySucessWithResult:response];
                }
            }
                break;
            default:
            {
                [RTAlertHelper alertWithTitle:@"支付结果" message:@"支付失败"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didPayFailWithResult:)] ) {
                    [self.delegate didPayFailWithResult:response];
                }
            }
                break;
        }
    }
}


+(void)responseWXWith:(WXMediaMessage *)message
{
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    if ([WXApi sendResp:resp]) {
        RTLog(@"sucess %@ ; code %d",[resp errStr],[resp errCode]);
    }
    else
    {
        RTLog(@"fail %@ ; code %d",[resp errStr],[resp errCode]);
    }
    
    
}


+(void)shareStoreWithStore:(StoreWrapDTO *)store image:(UIImage *)image scene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"宴预餐厅分享";
    message.description = [NSString stringWithFormat:@"舌尖上的【宴预】为您分享不得不去的品质餐厅【%@】。亲～还在犹豫吗？拿起手机马上下载【宴预】预定吧！再有没有什么能阻挡一颗吃货的心！",store.storeView.name];
    [message setThumbImage:image];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = [RTWeiXinHelper convertStoreShareDataWith:store.storeView.id];
    
    if (WXSceneTimeline == scene) {
        ext.url = @"http://as.yanyu8.com/app";
        message.title = [NSString stringWithFormat:@"舌尖上的【宴预】为您分享不得不去的品质餐厅【%@】。亲～还在犹豫吗？拿起手机马上下载【宴预】预定吧！再有没有什么能阻挡一颗吃货的心！",store.storeView.name];;
    }
    
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];

}


+(void)shareStoreToTimelineWithStore:(StoreWrapDTO *)store image:(UIImage *)image scene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = store.storeView.name;
    message.description = [NSString stringWithFormat:@"舌尖上的【宴预】为您分享不得不去的品质餐厅【%@】。亲～还在犹豫吗？拿起手机马上下载【宴预】预定吧！再有没有什么能阻挡一颗吃货的心！",store.storeView.name];
    [message setThumbImage:image];
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}


+(void)shareBookingOrderWithTrade:(TradeNewDTO *)trade
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"邀请函";
    message.description = [NSString stringWithFormat:@"您亲爱的朋友%@邀请您于%@ %@ 前往%@就餐。",trade.tradeTable.contact,[trade.mealDate chineseWeekAndDay],[trade.mealDate stringHHmmFromDate],trade.storeName];
    [message setThumbImage:[UIImage imageNamed:@"114.png"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = [RTWeiXinHelper convertBookingDataWithTrade:trade];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}


+(NSString *)convertStoreShareDataWith:(NSNumber *)storeId
{
    NSDictionary *dic = @{SocialTypeName: @(SocialTypeStore),SocialTypeStoreId:storeId};
    return [NSJSONSerialization convertToJsonStringWithObject:dic];
}


+(NSString *)convertBookingDataWithTrade:(TradeNewDTO *)trade
{
    
    NSDictionary *dic = @{SocialTypeName: @(SocialTypeBooking),SocialTypeTrade:[NSJSONSerialization convertToJsonStringWithObject:[trade toDictionary]]};
    return [NSJSONSerialization convertToJsonStringWithObject:dic];
}


-(void)payWithPrepay:(PrepayDTO *)prepay delegate:(id<RTAlipayHelpDelegate>)delegate
{
    self.delegate = delegate;
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = prepay.partnerid;
    request.prepayId = prepay.prepayid;
    request.package = prepay.packages;
    request.nonceStr = prepay.noncestr;
    request.timeStamp = [prepay.timestamp integerValue];
    request.sign = prepay.sign;
    [WXApi safeSendReq:request];
}

@end
