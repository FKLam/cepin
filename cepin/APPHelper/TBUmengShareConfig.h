//
//  TBUmengShareConfig.h
//  cepin
//
//  Created by zhu on 14/12/27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface TBUmengShareConfig : NSObject

+(void)configUmeng;
+(void)didSelectSocialPlatform:(NSString *)platformName vCtrl:(UIViewController*)vCtrl title:(NSString*)title content:(NSString*)content url:(NSString*)url imageUrl:(NSString*)imgUrl completion:(UMSocialDataServiceCompletion)completion;

@end
