//
//  RTWeiXinHelper.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-16.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "RTAlipayHelp.h"

typedef enum {
    SocialTypeStore    = 100,//餐厅分享数据
    SocialTypeDish     = 101,//菜品分享
    SocialTypeBooking  = 102,//订单分享
    SocialTypeTransmit = 103,//订单转发
}SocialType;


extern NSString *const SocialTypeName;
extern NSString *const SocialTypeStoreId;
extern NSString *const SocialTypeTrade;
extern NSString *const SocialTypeBookingDinner;
extern NSString *const SocialTypeBookingTable;
extern NSString *const SocialTypeStoreWrap;



@interface RTWeiXinHelper : NSObject<WXApiDelegate>


+(id)shareInstance;

+(void)responseWXWith:(WXMediaMessage *)message;

//微信数据处理方法
+(void)shareStoreWithStore:(StoreWrapDTO *)store image:(UIImage *)image scene:(int)scene;

+(void)shareStoreToTimelineWithStore:(StoreWrapDTO *)store image:(UIImage *)image scene:(int)scene;

+(void)shareBookingOrderWithTrade:(TradeNewDTO *)trade;


+(NSString *)convertStoreShareDataWith:(NSNumber *)storeId;

+(NSString *)convertBookingDataWithTrade:(TradeNewDTO *)trade;

//调用微信支付
-(void)payWithPrepay:(PrepayDTO *)prepay delegate:(id<RTAlipayHelpDelegate>)delegate;
@end
