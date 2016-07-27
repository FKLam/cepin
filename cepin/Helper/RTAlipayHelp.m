//
//  RTAlipayHelp.m
//  Daishu
//
//  Created by Ricky Tang on 14-3-14.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "RTAlipayHelp.h"
#import "PartnerConfig.h"
#import "AlixLibService.h"
#import "PayModel.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "RTAlertHelper.h"
#import "RTUrlHelper.h"


NSString *const NotificationAlipaySucess = @"NotificationAlipaySucess";
NSString *const NotificationAlipayFail = @"NotificationAlipayFail";

@interface RTAlipayHelp ()
@property(nonatomic,strong)id<RTAlipayHelpDelegate> payDelegate;
@end

@implementation RTAlipayHelp
+(id)shareInstance
{
    static RTAlipayHelp *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = self.new;
    });
    return shareInstance;
}



-(AlixPayOrder *)createAlixPayOrderWithPayModel:(PayModel *)model
{
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = model.tradeCode; //订单ID（由商家自行制定）
	order.productName = model.productName; //商品标题
	order.productDescription = model.productDescription; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",model.payPay]; //商品价格
	order.notifyURL =  [[[[RTUrlHelper shareInstance] urlModel] webRootUrl] stringByAppendingFormat:@"/alipayClientPay/alipayNotify"]; //回调URLhttp://192.168.1.187:8280/appmanagement/alipayClientPay/alipayNotify
    return order;
}


-(NSString *)signedStringWith:(NSString *)order
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:order];
    
    NSLog(@"%@",signedString);
    
    
    return signedString;
}


-(void)payWithPayModel:(PayModel *)model delegate:(id<RTAlipayHelpDelegate>)delegate
{
    self.payDelegate = delegate;
    
    AlixPayOrder *order = [self createAlixPayOrderWithPayModel:model];
    NSString *orderInfo = [order description];
    NSString *signedString = [self signedStringWith:orderInfo];
    NSString *appScheme = @"com.hssd.yanyu";
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedString, @"RSA"];
    RTLog(@"order string %@",orderString);
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
}

-(void)paymentResult:(NSString *)resultd
{
    //结果处理

    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];

	[self payHandle:result];
}


-(void)payHandle:(AlixPayResult *)result
{
    if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改

                if (self.payDelegate && [self.payDelegate respondsToSelector:@selector(didPaySucessWithResult:)]) {
                    [self.payDelegate didPaySucessWithResult:result];;
                }
			}
        }
        else
        {
            //交易失败

            if (self.payDelegate && [self.payDelegate respondsToSelector:@selector(didPayFailWithResult:)]) {
                [self.payDelegate didPayFailWithResult:result];
            }
            [RTAlertHelper alertWithMessage:@"支付失败"];
        }
    }
    else
    {
        //失败

        if (self.payDelegate && [self.payDelegate respondsToSelector:@selector(didPayFailWithResult:)]) {
            [self.payDelegate didPayFailWithResult:result];
        }
        [RTAlertHelper alertWithMessage:@"支付失败"];
    }
}



- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	[self payHandle:result];
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}
@end
