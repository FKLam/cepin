//
//  MemoryCacheData.h
//  cepin
//
//  Created by ceping on 14-11-21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserLoginDTO.h"
#import "UserInfoDTO.h"
#import "SubscriptionJobModelDTO.h"

@interface MemoryCacheData : NSObject
@property(nonatomic,strong)UserLoginDTO *userLoginData;
@property(nonatomic,strong)NSString     *rongYunTockenId;//融云id
@property(nonatomic,strong)NSString     *userId32;//
@property(nonatomic,assign)BOOL         isLogin;
@property(nonatomic,assign)BOOL         isRongyunLogin;
@property(nonatomic,assign)BOOL         isFirstLoad;
@property(nonatomic,assign)BOOL         isThirdLogin;
//@property(nonatomic,assign)BOOL         isFirstLoadResume;

+(MemoryCacheData*)shareInstance;

-(NSString*)userId;
-(NSString*)userTokenId;
-(NSString*)realName;

-(void)getChatToken;
-(void)getRongYun;
-(void)uploadJobSearch:(SendSubscriptionJobModelDTO*)bean;
-(void)disConnect;

@end
