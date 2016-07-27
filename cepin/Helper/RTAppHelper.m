//
//  RTAppHelper.m
//  yanyunew
//
//  Created by Ricky Tang on 14-4-21.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "RTAppHelper.h"
#import "NSUserDefaults+UserData.h"
#import "RTAPPUIHelper.h"
#import "FileManagerHelper.h"
#import "NSJSONSerialization+RTAddition.h"
#import "NSDate-Utilities.h"
#import "SDImageCache.h"
#import "NSDictionary+NetworkBean.h"

NSString *UpdateUserInfoPageNotification = @"UpdateUserInfoPage";

@implementation RTAppHelper

@synthesize appUserInfo=_appUserInfo;

+(id)shareInstance
{
    static RTAppHelper *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = self.new;
    });
    return shareInstance;
}

+(void)updateUserInfo
{
    
}

+(BOOL)isLogin
{
    NSUserDefaults *_user = [NSUserDefaults standardUserDefaults];
    
    return (_user.RT_LoginUserID.length>0 && _user.RT_LoginPassword.length > 0 && _user.RT_LoginUserName.length > 0);
}

+(void)loginOut
{
    NSUserDefaults *_user = [NSUserDefaults standardUserDefaults];
    _user.RT_LoginUserName = nil;
    _user.RT_LoginPassword = nil;
    _user.RT_LoginUserID = nil;
    
    [[RTAppHelper shareInstance] setAppUserInfo:nil];
}

-(void)setAppUserInfo:(UserInfoDTO *)info
{
    if (info == nil) {
        [FileManagerHelper deleteObjectWithFile:@"userInfo" folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
        return;
    }
    
    [FileManagerHelper writeObject:info file:@"userInfo" folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    _appUserInfo = info;
}

-(UserInfoDTO *)appUserInfo
{
    if (_appUserInfo) {
        return _appUserInfo;
    }
    
    _appUserInfo = [FileManagerHelper readObjectWithfile:@"userInfo" folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    
    return _appUserInfo;
}


+(void)saveUserLogoWithImage:(UIImage *)image
{
    NSUserDefaults *_user = [NSUserDefaults standardUserDefaults];
    
    if (image == nil) {
        [FileManagerHelper deleteObjectWithFile:[NSString stringWithFormat:@"user_%@.jpg",_user.RT_LoginUserID] folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    
    [FileManagerHelper writeData:data withFile:[NSString stringWithFormat:@"user_%@.jpg",_user.RT_LoginUserID] andFolder:nil andSandBoxFolder:kUseDocumentTypeLibraryCaches];
}


+(UIImage *)userLogoImage
{
    NSUserDefaults *_user = [NSUserDefaults standardUserDefaults];
    NSData *data = [FileManagerHelper readDataWithFolder:nil andFile:[NSString stringWithFormat:@"user_%@.jpg",_user.RT_LoginUserID] andSandBoxFolder:kUseDocumentTypeLibraryCaches];
    UIImage *image = [[UIImage alloc] initWithData:data];
    return image;
}





+(RACSignal *)lookingForCurrentLocation
{
    
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        
        NSInteger requestID = [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:20 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status){
            
            switch (status) {
                case INTULocationStatusServicesDenied:
                {
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您没有授权此app获得您的地理位置，请您在，设置->隐私->定位服务->Let's go->打开位置服务",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
                    [alerView showWithCompletionHandler:^(NSInteger buttonIndex){
                        
                        if (alerView.cancelButtonIndex == buttonIndex) {
                            return;
                        }
                        
                    }];
                    return;
                }
                    break;
                case INTULocationStatusError:

                default:
                    break;
            }
            
            RTLog(@"la %f long %f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
            [[RTAppHelper shareInstance] setCurrentLocation:currentLocation];
            [subscriber sendNext:RACTuplePack(currentLocation,@(status))];
            [subscriber sendCompleted];
            
        }];
        
        
        return [RACDisposable disposableWithBlock:^(void){
            
            [[INTULocationManager sharedInstance] cancelLocationRequest:requestID];
            
        }];
    }];
    
    
}

-(void)test
{
}

+(NSString *)distanceStringWithTargetLocation:(CLLocationCoordinate2D)location
{
    
    return nil;
}


+(NSString *)cacheString
{
    NSUInteger cacheSize = [[NSURLCache sharedURLCache] currentDiskUsage];
    cacheSize += [[SDImageCache sharedImageCache] getSize];
    
    float temp;
    if (cacheSize > 1024*1024) {
        temp = (float)(cacheSize/(1024*1024));
        return [NSString stringWithFormat:@"%.2fM",temp];
    }
    else if (cacheSize > 1024){
        temp = (float)(cacheSize/1024);
        return [NSString stringWithFormat:@"%.2fK",temp];
    }
    return [NSString stringWithFormat:@"%lu",(unsigned long)cacheSize];
}

+(void)appCommet
{
    if (IsIOS7) {
        [[UIApplication sharedApplication] openURL:APPIos7CommetUrl];
        return;
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:APPCommetUrl]) {
        return;
    }
    [[UIApplication sharedApplication] openURL:APPCommetUrl];
}
@end
