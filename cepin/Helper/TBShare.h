//
//  TBShare.h
//  cepin
//
//  Created by tassel.li on 14-5-22.
//  Copyright (c) 2014年 tassel.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBConfig.h"
#import <Frontia/Frontia.h>

/**
 * 分享回调
 */
typedef void (^ShareCompletedBlock)(NSDictionary *respones);
typedef void (^ShareFairedBlock)(int errorCode, NSString *errorMessage);
typedef void (^ShareCancelBlock)();

/**
 *  授权登录回调
 *
 *  @param user 用户信息
 */
typedef void (^LoginCompletedBlock)(FrontiaUser *user);
typedef void (^LoginFairedBlock)(int errorCode, NSString *errorMessage);
typedef void (^LoginCancelBlock)();



@interface TBShare : NSObject

/**
 *  配置分享
 */
+(void)ConfigurationShare;

/**
 *  显示分享菜单
 *
 *  @param paramsDic     分享内容:url,description,imageObj 等
 *  @param completeBlock 分享成功
 *  @param failedBlock   分享失败
 *  @param cancelBlock   取消分享
 */
+(void)ShowShareMenu:(NSDictionary *)paramsDic completed:(ShareCompletedBlock )completeBlock failed:(ShareFairedBlock )failedBlock cancel:(ShareCancelBlock )cancelBlock;

/**
 *  第三方登录
 *
 *  @param platform      平台信息
 *  @param completeBlock 授权登录完成得到User信息
 *  @param failedBlock   授权登录失败
 *  @param cancelBlock   取消授权登录
 */
+(void)ThirdPartLogin:(NSString *)platform completed:(LoginCompletedBlock )completeBlock failed:(LoginFairedBlock )failedBlock cancel:(LoginCancelBlock)cancelBlock;

/**
 *  清除认证授权
 */
+(void)clearAllAuthorization;
@end
