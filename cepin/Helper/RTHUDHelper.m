//
//  RTHUDHelper.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-23.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "RTHUDHelper.h"
#import "MBProgressHUD.h"

static MBProgressHUD *HUDView;

@implementation RTHUDHelper
+(void)showHUDViewType:(HUDViewType)type text:(NSString *)text hideAfter:(float)time
{
    [self showHUDViewType:type text:text hideAfter:time canTouchCancel:YES];
}


+(void)showHUDViewType:(HUDViewType)type text:(NSString *)text hideAfter:(float)time canTouchCancel:(BOOL)isCanTouchCancel
{
    if (HUDView) {
        __strong MBProgressHUD *hud = HUDView;
        HUDView = nil;
        [hud hide:NO];
    }
    
    HUDView = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
    [[UIApplication sharedApplication].keyWindow addSubview:HUDView];
	
    switch (type) {
        case HUDViewTypeRight:
            HUDView.mode = MBProgressHUDModeCustomView;
            HUDView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD_right"]];
            break;
        case HUDViewTypeWrong:
            HUDView.mode = MBProgressHUDModeCustomView;
            HUDView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD_wrong"]];
            break;
        case HUDViewTypeWait:
            HUDView.mode = MBProgressHUDModeIndeterminate;
            break;
        case HUDViewTypeText:
            HUDView.mode = MBProgressHUDModeText;
            break;
            
        default:
            break;
    }
    
	HUDView.labelText = text;
	HUDView.animationType = MBProgressHUDAnimationZoom;
    HUDView.removeFromSuperViewOnHide = YES;
    HUDView.isTouchCancel = isCanTouchCancel;
	[HUDView show:YES];
    
    if (time > 0) {
        [HUDView hide:YES afterDelay:time];
    }

}


+(void)hideHUDView
{
    [HUDView hide:YES];
    HUDView = nil;
}



@end
