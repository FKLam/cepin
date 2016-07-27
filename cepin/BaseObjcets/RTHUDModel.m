//
//  RTHUDModel.m
//  letsgo
//
//  Created by Ricky Tang on 14-7-30.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "RTHUDModel.h"

@implementation RTHUDModel

+(instancetype)hudWithCode:(HUDCode)code
{
    RTHUDModel *model = nil;
    
    switch (code) {
//        case HUDCodeNone:
//        case HUDCodeSucess:
//        case HUDCodeReflashSucess:
//        case HUDCodeGoOn:
//        {
//            
//        }
//        break;
        case HUDCodeDownloading:
        model = [RTHUDModel hudWithHUDType:HUDViewTypeWait string:HUDDefaultDownloadData time:HUDDoNotHideTime canTouch:NO code:HUDCodeDownloading];
        break;
        default:
            model = [RTHUDModel new];
            model.hudCode = code;
            return model;
        break;
    }
    
    return model;
}

+(instancetype)hudWithHUDType:(HUDViewType)type string:(NSString *)string time:(float)time canTouch:(BOOL)isCanTouch code:(HUDCode)code
{
    RTHUDModel *model = [RTHUDModel new];
    model.type = type;
    model.hudString = string;
    model.time = time;
    model.isCanTouch = isCanTouch;
    model.hudCode = code;
    return model;
}


@end
