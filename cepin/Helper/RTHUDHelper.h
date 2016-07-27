//
//  RTHUDHelper.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-23.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HUDShortDisplayTime 0.3
#define HUDNormalDisplayTime 1.0f
#define HUDLongDisplayTime 3.0f
#define HUDDoNotHideTime -1.0f

#define HUDDefaultNullDataString @"对不起没有数据了"
#define HUDDefaultDownloadData @"数据加载中"
#define HUDDefaultDownloadLost @"数据加载失败"
#define HUDDefaultUpdateDataNow @"数据提交中"
#define HUDDefaultUpdateLostString @"数据提交失败"
#define HUDDefauLtUpdateSuccess @"数据提交成功"


typedef enum {
    HUDViewTypeRight = 1,
    HUDViewTypeWrong,
    HUDViewTypeWait,
    HUDViewTypeText,
    
}HUDViewType;



@interface RTHUDHelper : NSObject
+(void)showHUDViewType:(HUDViewType)type text:(NSString *)text hideAfter:(float)time;

+(void)showHUDViewType:(HUDViewType)type text:(NSString *)text hideAfter:(float)time canTouchCancel:(BOOL)isCanTouchCancel;

+(void)hideHUDView;


@end
