//
//  RTHUDModel.h
//  letsgo
//
//  Created by Ricky Tang on 14-7-30.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HUDCodeInit = 0,
    HUDCodeNone = 199,
    HUDCodeSucess = 200,
    HUDCodeReflashSucess,
    hudCodeUpdateSucess,
    HUDCodeDownloading,
    HUDCodeGoOn,
    HUDCodeLoadMore,
    HUDCodeCancel,
    HUDCodeNetWork,
}HUDCode;


@interface RTHUDModel : NSObject
@property(nonatomic,assign)HUDViewType type;
@property(nonatomic,strong)NSString *hudString;
@property(nonatomic,assign)float time;
@property(nonatomic,assign)BOOL isCanTouch;
@property(nonatomic,assign)HUDCode hudCode;

+(instancetype)hudWithCode:(HUDCode)code;

+(instancetype)hudWithHUDType:(HUDViewType)type string:(NSString *)string time:(float)time canTouch:(BOOL)isCanTouch code:(HUDCode)code;
@end
