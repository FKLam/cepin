//
//  RTAppHelper.h
//  yanyunew
//
//  Created by Ricky Tang on 14-4-21.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfoDTO.h"
#import "INTULocationManager.h"


extern NSString *UpdateUserInfoPageNotification;

@interface RTAppHelper : NSObject

+(id)shareInstance;


@property(nonatomic,strong)UserInfoDTO *appUserInfo;

+(void)updateUserInfo;

+(BOOL)isLogin;

+(void)loginOut;
//头像处理
+(void)saveUserLogoWithImage:(UIImage *)image;
+(UIImage *)userLogoImage;


@property(nonatomic,strong)CLLocation *currentLocation;

+(RACSignal *)lookingForCurrentLocation;

+(NSString *)distanceStringWithTargetLocation:(CLLocationCoordinate2D)location;

+(NSString *)cacheString;

+(void)appCommet;
@end
