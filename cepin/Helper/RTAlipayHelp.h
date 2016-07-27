//
//  RTAlipayHelp.h
//  Daishu
//
//  Created by Ricky Tang on 14-3-14.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const NotificationAlipaySucess;
extern NSString *const NotificationAlipayFail;

@class PayModel;
@class AlixPayResult;

@protocol RTAlipayHelpDelegate <NSObject>

-(void)didPaySucessWithResult:(id)result;
-(void)didPayFailWithResult:(id)result;

@end

@interface RTAlipayHelp : NSObject

+(id)shareInstance;

- (void)parse:(NSURL *)url application:(UIApplication *)application;

-(void)payWithPayModel:(PayModel *)model delegate:(id<RTAlipayHelpDelegate>)delegate;
@end
