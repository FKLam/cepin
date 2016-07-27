//
//  TBAppDelegate.m
//  cepin
//
//  Created by tassel.li on 14-10-9.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "TBAppDelegate.h"
#import "RESideMenu.h"
#import "BaseNavigationViewController.h"
#import "UMSocialData.h"

#import "RTNetworking+PublicData.h"

#import "FileManagerHelper.h"
#import "JSONModelSQLManager.h"

#import "FirstLoadVC.h"

#import "UMSocial.h"
#import "MobClick.h"

#import "TBUmengShareConfig.h"
#import "AutoLoginVM.h"
#import "RTNetworking+Banner.h"
#import "RTNetworking+User.h"
#import "BannerModel.h"
#import "RTPictureHelper.h"
#import "MaskVC.h"
#import "SignupGuideResumeVC.h"
#import "SchoolSignupGuideResumeVC.h"
#import "UMessage.h"
#import "DynamicWebVC.h"
#import "ForgetPasswordVC.h"
#import "AddDescriptionVC.h"
#import "GuideStatesMv.h"
#import "SignupExpectJobVC.h"
#import "SendResumeVC.h"
#import "DynamicSystemDetailVC.h"
#import "LoginVC.h"
#import "NewJobDetialVC.h"
#import "CompanyDetailVC.h"
#import "JobSearchResultVC.h"
#import "LoginVC.h"
#import "MJExtension.h"
#import "DynamicExamNotHomeVC.h"
#import "CPCompanyDetailController.h"
#import "CPHomePositionDetailController.h"
#import "SignupVC.h"
#import "AllResumeVC.h"
#import "RecommendVC.h"
//for mac
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
//for idfa
#import <AdSupport/AdSupport.h>
#import "ExamReportVC.h"

#import "CPWNdUncaughtExceptionHander.h"
#import "DynamicExamDetailVC.h"
@interface TBAppDelegate ()
@property (nonatomic, strong) AFNetworkReachabilityManager *mgr;
@end
@implementation TBAppDelegate

//894486180
- (void)push
{
    
}
- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}
- (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}
- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}
- (void)UMWatchChannel
{
    NSString * appKey = @"5327f46956240bdabc015633";
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [self macString];
    NSString * idfa = [self idfaString];
    NSString * idfv = [self idfvString];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.5];
    [self.window makeKeyAndVisible];
    dispatch_async(dispatch_get_main_queue(), ^{
        [TBUmengShareConfig configUmeng];
        [self UMWatchChannel];
        [JSONModelSQLManager shareManager];
        AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
        self.mgr = mgr;
        [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch ( status )
            {
                case AFNetworkReachabilityStatusNotReachable:
                    self.isHaveNetwork = NO;
                    break;
                default:
                {
                    self.isHaveNetwork = YES;
                    if(![MemoryCacheData shareInstance].isLogin)
                    {
                        self.viewModel = [AutoLoginVM new];
                        self.viewModel.isShowLoading = NO;
                        self.viewModel .showMessageVC = self.navi;
                        [self.viewModel autoLogin];
                    }
                }
                    break;
            }
        }];
        [mgr startMonitoring];
        [self StartUploadDevice];
        //push友盟
        [self pushYouMeng:launchOptions];
    });
    //配置样式
    [RTAPPUIHelper appearence];
    if (launchOptions != nil) {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil) {
            // 获取友盟推送的消息
            [self performSelector:@selector(dealWithUmengMsgByBack:) withObject:dictionary afterDelay:6.f];
        }
    }
    if ([RTPictureHelper fileExists:@"CepinBannerOne.png"])
    {
        // 有广告时执行这里
        [self ChangeToBanner];
    }
    else
    {
        [self ChangeToMask];
        [self performSelector:@selector(autoLogin) withObject:nil afterDelay:0.25f];
    }
    [UMessage setLogEnabled:YES];
    return YES;
}
// 只能调用系统键盘的代码
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    if ( [extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"] )
    {
        return NO;
    }
    return YES;
}
//检测版本
-(void)checkVersion
{
    NSString *appStoreUrl = @"https://itunes.apple.com/lookup?id=894486180";
    NSURL *url = [NSURL URLWithString:appStoreUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}
//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receiveData = [NSMutableData data];//数据存储对象的的初始化
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    self.trackUrl = [[infoContent objectAtIndex:0] objectForKey:@"trackViewUrl"];
    NSString *newStr = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:currentVersion];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *description = [[infoContent objectAtIndex:0] objectForKey:@"releaseNotes"];
    if ([currentVersion intValue] < [newStr intValue]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:description delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"前往更新",nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //跳转到appstore应用详情页面
    if(1==buttonIndex)
    {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackUrl]];
    }
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    NSLog(@"%@",[error localizedDescription]);
    
}
#pragma mark - BannerVCDelegate
- (void)jumpAdvertisement
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoLogin) object:nil];
    [self autoLogin];
}
- (void)cancelAutoLogin:(NSString*)url
{
    if(![MemoryCacheData shareInstance].isLogin)
    {
        self.viewModel = [AutoLoginVM new];
        self.viewModel.isShowLoading = NO;
        self.viewModel .showMessageVC = self.navi;
        [self.viewModel autoLogin];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoLogin) object:nil];
    url = [[NSUserDefaults standardUserDefaults]objectForKey:@"banner_url"];
    NSString *title = [[NSUserDefaults standardUserDefaults]objectForKey:@"banner_title"];
    DynamicWebVC *vc = [[DynamicWebVC new] initWithFullUrl:url title:title isBigADCome:YES];
    self.navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = self.navi;
}
- (void)bannerVC:(BannerVC *)bannerVC isFinishTime:(BOOL)isFinishTime
{
//    if ( [MemoryCacheData shareInstance].isLogin )
//        return;
    if ( isFinishTime )
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoLogin) object:nil];
        [self autoLogin];
    }
}
- (void)pushYouMeng:(NSDictionary*)launchOptions
{
    [UMessage startWithAppkey:UMENG_KEY launchOptions:launchOptions];
    if (IsIOS8)
    {
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc]init];
        action1.identifier = @"action1_identifier";
        action1.title = @"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;
        UIMutableUserNotificationAction * action2 = [[UIMutableUserNotificationAction alloc]init];
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }
    else
    {
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
    [UMessage setLogEnabled:YES];
}
-(void)autoLogin
{
    //判断是否首次启动
    NSNumber *isFirstLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLaunch"];
    if ( isFirstLaunch && isFirstLaunch.intValue == 1 )
    {
        //进去程序主页面
        [self translate2Home];
    }
    self.viewModel = [AutoLoginVM new];
    self.viewModel.isShowLoading = NO;
    self.viewModel .showMessageVC = self.navi;
    [self.viewModel autoLogin];
    @weakify(self)
    [RACObserve(self.viewModel, boolNumber) subscribeNext:^(id stateCode){
        @strongify(self);
        if (stateCode)
        {
            if ([stateCode isKindOfClass:[NSNumber class]])
            {
                self.boolNumber = (NSNumber*)stateCode;
                if (self.boolNumber.intValue == 1)
                {
                    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"isFirstLaunch"];
                    if (self.viewModel.login.ResumeCount.intValue > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self ChangeToMainTwo];
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobiel];
                            self.navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                            self.window.rootViewController = self.navi;
                        });
                    }
                }
                else
                {
                    //判断是否首次启动
                     NSNumber *isFirstLaunch = [[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstLaunch"];
                    if (isFirstLaunch && isFirstLaunch.intValue == 1) {
                        //进去程序主页面
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self ChangeToMainTwo];
                        });
                    }
                    else
                    {
                        //首次启动
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"IsThirdPartLogin"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self ChangeToMainOne];
                        });
                    }
                    
                }
            }
        }
    }];
   [self StartLoadFirstBanner];
}
-(void)ChangeToMask
{
    MaskVC *vc = [MaskVC new];
    self.navi  = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = self.navi;
}
-(void)ChangeToLogin
{
    LoginVC *vc = [LoginVC new];
    [self.navi pushViewController:vc animated:YES];
}
-(void)ChangeToForget{
    ForgetPasswordVC *forget = [ForgetPasswordVC new];
    self.navi =[[BaseNavigationViewController alloc] initWithRootViewController:forget];
    self.window.rootViewController = self.navi;
}
-(void)ChangeToBanner
{
    BannerVC *vc = [BannerVC new];
    vc.delegate = self;
    self.navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = self.navi;
}
-(void)ChangeToMainOne
{
#pragma mark - 获取是否纪录了首次运行程序
    NSNumber *launchButNotLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"launchButNotLogin"];
    if( launchButNotLogin && launchButNotLogin.intValue == 1 )
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        LoginVC *vc = [[LoginVC alloc] init];
        self.navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        for ( UIView *subView in self.window.subviews )
        {
            if ( [subView isKindOfClass:[TBLoading class]]  && subView.tag == 10086 )
            {
                TBLoading *loading = (TBLoading *)subView;
                loading = nil;
            }
        }
        self.window.rootViewController = self.navi;
    }
    else
    {
        FirstLoadVC *vcMian0 = [FirstLoadVC new];
        self.navi = [[BaseNavigationViewController alloc] initWithRootViewController:vcMian0];
        self.window.rootViewController = self.navi;
    }
}
//跳转到社招 校招简历引导界面
-(void)guidResumeVC:(NSString*) mobile isSocialResume:(Boolean)isSocial comeFromString:(NSString *)comeFromString
{
    if( isSocial )
    {
        SignupGuideResumeVC *vc = [[SignupGuideResumeVC alloc] initWithMobiel:mobile comeFromString:comeFromString];
        self.navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        self.window.rootViewController = self.navi;
    }
    else
    {
        SchoolSignupGuideResumeVC *vc = [[SchoolSignupGuideResumeVC alloc] initWithMobiel:mobile comeFromString:comeFromString];
       self.navi = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        self.window.rootViewController = self.navi;
    }
}
-(void)ChangeToMainTwo
{
    TBTabViewController *vc = [TBTabViewController new];
    self.navi = [[BaseNavigationViewController alloc]initWithRootViewController:vc];
    for ( UIView *subView in self.window.subviews )
    {
        if ( [subView isKindOfClass:[TBLoading class]]  && subView.tag == 10086 )
        {
            TBLoading *loading = (TBLoading *)subView;
            loading = nil;
        }
    }
    self.window.rootViewController = self.navi;
    [self updateAppVersion];
}
- (void)translate2Home
{
    TBTabViewController *vc = [TBTabViewController new];
    vc.isTranslate = YES;
    self.navi = [[BaseNavigationViewController alloc]initWithRootViewController:vc];
    self.window.rootViewController = self.navi;
}
-(void)updateAppVersion{
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    if (!strUser) {
        return;
    }
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    RACSignal *signal = [[RTNetworking shareInstance] updateAppVersion:currentVersion UserId:strUser];
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            [self updateApptoken];
            //            NSLog(@"上传apptoken成功");
        }else{
            //            NSLog(@"上传apptoken失败");
        }
    } error:^(NSError *error){
    }];
}
-(void)updateApptoken{
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    NSString *apptoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"uapp_token"];
    if (!strTocken || !apptoken) {
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance] updateAppTokenWithUserId:strUser tokenId:strTocken appDeviceToken:apptoken];
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
//            NSLog(@"上传apptoken成功");
        }else{
//            NSLog(@"上传apptoken失败");
        }
    } error:^(NSError *error){
    }];
}
//广告图
-(void)StartLoadFirstBanner
{
    RACSignal *signal = [[RTNetworking shareInstance]getBanner:1];
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic objectForKey:@"Data"];
            if (array && array.count > 0)
            {
                BannerModel *model = [BannerModel beanFromDictionary:array[0]];
               
                [[NSUserDefaults standardUserDefaults]setObject:model.Title forKey:@"banner_title"];
                 [[NSUserDefaults standardUserDefaults]setObject:model.LinkUrl forKey:@"banner_url"];
                NSString *url = model.LinkUrl;
                if([url rangeOfString:@"http://"].location !=NSNotFound)//_roaldSearchText
                {
                    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isShow"];
                }else{
                     [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isShow"];
                }
                [RTPictureHelper saveImage:model.ImgUrl name:@"CepinBannerOne.png"];
            }
            else
            {
                //移除本地图片
                [RTPictureHelper deleteImage:@"CepinBannerOne.png"];
            }
        }else{
            //移除本地图片
            [RTPictureHelper deleteImage:@"CepinBannerOne.png"];
            
        }
    } error:^(NSError *error){
    }];
}
-(void)StartUploadDevice
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* phoneModel = [[UIDevice currentDevice] model];
        RACSignal *signal =[[RTNetworking shareInstance] openAppWithUUID:UUID_KEY openRefer:phoneModel];
        [signal subscribeNext:^(id x) {
            RTLog(@"上传设备信息成功!");
        } error:^(NSError *error) {
            RTLog(@"上传设备信息失败!");
        }];
        
    });
}
-(void)startDataBaseDownLoad
{
    //NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES)
    
    /*下载完解压之后要删除本地的zip压缩文件，避免下次下载的时候不成功
     NSString *filePath = [FileManagerHelper selectedFolderPathWith:kUseDocumentTypeLibraryCaches];
     
     [[TCBlobDownloadManager sharedDownloadManager]startDownloadWithURL:[NSURL URLWithString:@"http://app2.cepin.com/resource/DB1.2.zip"] customPath:filePath firstResponse:^(NSURLResponse *response) {
     } progress:^(float receivedLength, float totalLength) {
     } error:^(NSError *error) {
     } complete:^(BOOL downloadFinished, NSString *pathToFile) {
     RTLog(@"download success!");
     }];*/
}
-(void)initYouMeng
{
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH  channelId:nil];
    [UMSocialData setAppKey:UMENG_KEY];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
// 获取苹果推送权限成功。
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"token == %@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    if ( 0 < [token length] )
    {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"uapp_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    [self dealWithUmengMsg:userInfo isActive:self.isActive];
}
-(void)dealWithUmengMsg:(NSDictionary *)userInfo isActive:(BOOL)isActive{
    //判断app是否在前台
    if (isActive) {
        //可以发送通知。。待处理
        NSLog(@"推送。。。");
    }
    else
    {
        //处理推送的消息
        [self dealWithUmengMsgByBack:userInfo];
    }
}
-(void)dealWithUmengMsgByBack:(NSDictionary *)userInfo{
    BOOL isLogin;
    if (![MemoryCacheData shareInstance].isLogin)
    {
        isLogin = NO;
    }else{
        isLogin = YES;
    }
    if ([[userInfo allKeys] containsObject:@"custom"])
    {
            NSString *custom = [userInfo valueForKey:@"custom"];
            if (custom && [custom isEqualToString:@"打开专题"])
            {
                if(!isLogin)
                {
                    LoginVC *vc = [[LoginVC alloc] initWithComeFromString:@"notificationshomeTestList" notificationDict:userInfo];
                    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                    NSArray *childArray = self.navi.childViewControllers;
                    UIViewController *parentVC = childArray[0];
                    UIViewController *childVC = parentVC.childViewControllers[0];
                    [childVC presentViewController:nav animated:YES completion:nil];
                }
                else
                {
                    NSString *title = [userInfo valueForKey:@"title"];
                    NSString *url = [userInfo valueForKey:@"url"];
                    DynamicExamDetailVC  *vc = [[DynamicExamDetailVC alloc] initWithUrl:url examDetail:examDetailOther];
                        vc.title = title;
                        vc.strTitle = title;
                        vc.urlPath = url;
    //                DynamicWebVC *vc = [[DynamicWebVC alloc]initWithTitleAndlUrl:title url:url];
                    [self.navi pushViewController:vc animated:YES];
                }
            }
            else if(custom && [custom isEqualToString:@"OpenApplyList"])
            {
                if(!isLogin)
                {
                    LoginVC *vc = [[LoginVC alloc] initWithComeFromString:@"homedelivery"];
                    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                    NSArray *childArray = self.navi.childViewControllers;
                    UIViewController *parentVC = childArray[0];
                    UIViewController *childVC = parentVC.childViewControllers[0];
                    [childVC presentViewController:nav animated:YES completion:nil];
                    
                }else{
                  //            //打开投递记录
                  SendResumeVC *vc = [SendResumeVC new];
                  [self.navi pushViewController:vc animated:YES];
                }
                
            }else if(custom && [custom isEqualToString:@"OpenSingleMessage"] ){
                if(!isLogin){
                    LoginVC *vc = [[LoginVC alloc] initWithComeFromString:@"homelogin"];
                    [self.navi pushViewController:vc animated:YES];
                }
                else
                {
                //打开站内信息
                    NSString *msgid = [userInfo valueForKey:@"MessageId"];
                    DynamicSystemDetailVC *vc = [[DynamicSystemDetailVC alloc]initWithBeanId:msgid];
                    [self.navi pushViewController:vc animated:YES];
                }
            }else if(custom && [custom isEqualToString:@"搜索筛选"] ){
                //打开搜索
                // 消息推送搜索
                NSString *wordView = [userInfo valueForKey:@"wordView"];//搜索关键字
                NSString *functionView = [userInfo valueForKey:@"functionView"];//职能
                NSString *gznxView = [userInfo valueForKey:@"gznxView"];//工作年限
                NSString *salaryView = [userInfo valueForKey:@"salaryView"];//薪酬
                NSString *gzxzView = [userInfo valueForKey:@"gzxzView"];//工作性质
                NSString *regionView = [userInfo valueForKey:@"regionView"];//城市
                NSString *zplxView = [userInfo valueForKey:@"zplxView"];//招聘类型
                NSString *degree = [userInfo valueForKey:@"Degree"];//学历
                
                JobSearchResultVC *vc = [[JobSearchResultVC alloc]initWithKeyWord:wordView city:regionView JobFunction:functionView Salary:salaryView PositionType:zplxView EmployType:gzxzView WorkYear:gznxView Degree:degree];
                [self.navi pushViewController:vc animated:YES];
                
            }
            else if(custom && [custom isEqualToString:@"测一测"] )
            {
                //打开测一测页面
                DynamicExamNotHomeVC *vc = [[DynamicExamNotHomeVC alloc]initWithType:examTwo];
                [self.navi pushViewController:vc animated:YES];
            }
            else if(custom && [custom isEqualToString:@"职位详情"] )
            {
                //打开职位详情
                NSString *postId = [userInfo valueForKey:@"postId"];
                CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
                [companyDetailVC configWithPositionId:postId];
                [self.navi pushViewController:companyDetailVC animated:YES];
               
            }
            else if(custom && [custom isEqualToString:@"企业详情"] )
            {
                //打开企业详情
                NSString *comId = [userInfo valueForKey:@"companyId"];
                CPCompanyDetailController *companyDetailVC = [[CPCompanyDetailController alloc] init];
                [companyDetailVC configWithPositionWithCompanyId:comId];
                [self.navi pushViewController:companyDetailVC animated:YES];
            }
        
            else if(custom && [custom isEqualToString:@"登录页"] )
            {
                //打开登录页
                LoginVC *vc = [[LoginVC alloc]init];
                [self.navi pushViewController:vc animated:YES];
            }else if(custom && [custom isEqualToString:@"注册页"] )
            {
                SignupVC *vc = [[SignupVC alloc]init];
                [self.navi pushViewController:vc animated:YES];
            }
            else if(custom && [custom isEqualToString:@"我的简历"] )
            {
                if( !isLogin )
                {
                    LoginVC *vc = [[LoginVC alloc] initWithComeFromString:@"homeResume"];
                    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                    NSArray *childArray = self.navi.childViewControllers;
                    UIViewController *parentVC = childArray[0];
                    UIViewController *childVC = parentVC.childViewControllers[0];
                    [childVC presentViewController:nav animated:YES completion:nil];
                }
                else
                {
                  //我的简历
                  AllResumeVC *vc = [AllResumeVC new];
                  [self.navi pushViewController:vc animated:YES];
                }
            }
            else if(custom && [custom isEqualToString:@"职位列表"] )
            {
                //打开首页
                RecommendVC *vc = [[RecommendVC alloc]init];
                [self.navi pushViewController:vc animated:YES];
            }
    }
    else if ([[userInfo allKeys] containsObject:@"type"])
    {
        NSString *typeString = [userInfo valueForKey:@"type"];
        if ( ![typeString isEqualToString:@"OpenApplyList"] )
            return;
        if(!isLogin)
        {
            LoginVC *vc = [[LoginVC alloc] initWithComeFromString:@"homedelivery"];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            NSArray *childArray = self.navi.childViewControllers;
            UIViewController *parentVC = childArray[0];
            UIViewController *childVC = parentVC.childViewControllers[0];
            [childVC presentViewController:nav animated:YES completion:nil];
            
        }else{
            //            //打开投递记录
            SendResumeVC *vc = [SendResumeVC new];
            [self.navi pushViewController:vc animated:YES];
        }
    }
}
- (void)searchOnAndroid:(NSString *)searchKey{
    JobSearchResultVC *vc = [[JobSearchResultVC alloc]initWithKeyWord:searchKey];
    [self.navi pushViewController:vc animated:YES];

};
- (void)postOnAndroid:(NSString *)params{
    NSLog(@"params = %@",params.description);
    NSDictionary *dic = [params JSONObject];
    NSString *pstId = [dic valueForKey:@"postId"];
    if (nil == pstId) {
        pstId = @"";
    }
    CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
    [companyDetailVC configWithPositionId:pstId];
    [self.navi pushViewController:companyDetailVC animated:YES];
}
- (void)companyOnAndroid:(NSString *)companyId{
    //打开企业详情
    CPCompanyDetailController *companyDetailVC = [[CPCompanyDetailController alloc] init];
    [companyDetailVC configWithPositionWithCompanyId:companyId];
    [self.navi pushViewController:companyDetailVC animated:YES];
}
-(void)setHotCityData:(NSArray *)cityData{
    if(nil == self.cityData){
        self.cityData  = [NSMutableArray arrayWithArray:cityData];
    }
}
-(void)toInviteCepinListWithMsg:(BOOL)isMsg{
    if(isMsg){
         [self.navi popViewControllerAnimated:YES completed:nil];
        ExamReportVC *vc = [[ExamReportVC alloc]init];
        [self.navi pushViewController:vc animated:YES];
    }else{
        [self.navi popViewControllerAnimated:YES completed:nil];
    }
    
}
-(NSMutableArray *)getHotCityData{
    return self.cityData;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.isActive = NO;
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.isActive = YES;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
}
@end
