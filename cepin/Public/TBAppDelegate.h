//
//  TBAppDelegate.h
//  cepin
//
//  Created by tassel.li on 14-10-9.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCBlobDownloadManager.h"
#import "TCBlobDownload.h"

#import "BaseNavigationViewController.h"
#import "AutoLoginVM.h"
#import "TBTabViewController.h"
#import "REFrostedViewController.h"
#import "BannerVC.h"
@interface TBAppDelegate : UIResponder <UIApplicationDelegate,BannerDelegate,UIAlertViewDelegate>
{
    UIImageView  *firstLoadImage;
    NSString      *currentCityName;
}
@property (strong, nonatomic)UIWindow *window;
@property (strong, nonatomic)BaseNavigationViewController *loginMainVC;
@property(nonatomic,strong)REFrostedViewController *sideMenueController;
@property(nonatomic,strong)TBTabViewController *firstController;
@property(strong,nonatomic)TCBlobDownload *downloader;
@property (strong,nonatomic)AutoLoginVM *viewModel;
@property(strong,nonatomic)NSNumber *boolNumber;
@property(strong,nonatomic)NSMutableData *receiveData;
@property(strong,nonatomic)NSString *trackUrl;
@property(strong,nonatomic) BaseNavigationViewController *navi;
@property(nonatomic,assign)BOOL isActive;
@property(nonatomic,strong)NSMutableArray *cityData;//热门城市数据
@property(nonatomic,strong)NSString *homeCity;//首页的城市
@property (nonatomic, assign) BOOL isHaveNetwork;

-(void)ChangeToMainOne;
-(void)ChangeToMainTwo;
-(void)checkVersion;
-(void)ChangeToForget;
-(void)ChangeToLogin;
-(void)guidResumeVC:(NSString*) mobile isSocialResume:(Boolean)isSocial comeFromString:(NSString *)comeFromString;
- (void)searchOnAndroid:(NSString *)searchKey;
- (void)postOnAndroid:(NSString *)params;
- (void)companyOnAndroid:(NSString *)companyId;
- (void)toInviteCepinListWithMsg:(BOOL)isMsg;
-(void)setHotCityData:(NSArray *)cityData;//设置热门城市数据
-(NSMutableArray *)getHotCityData;//获取热门城市数据

@end
