//
//  TBTabViewController.m
//  cepin
//
//  Created by ricky.tang on 14-10-16.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "TBTabViewController.h"
#import "LoginVC.h"
#import "SignupVC.h"
#import "RTTabView.h"
#import "TKRoundedView.h"
#import "UIViewController+NavicationUI.h"
#import "RecommendVC.h"
#import "DynamicSystemVC.h"
#import "JobSearchVC.h"
#import "DynamicExamVC.h"
#import "MeVC.h"
#import "AllResumeVC.h"
#import "TBTabViewModel.h"
#import "DynamicExamDetailVC.h"
#import <CoreLocation/CoreLocation.h>
#import "AlertDialogView.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"
@interface TBTabViewController ()<UIAlertViewDelegate,CLLocationManagerDelegate,RTTabDelegate>
{
        NSString       *currentCityName;
}
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,strong)TBTabViewModel *tbViewModel;
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)RecommendVC *rVc;
@property(nonatomic,strong)AlertDialogView *alertView;
@end
@implementation TBTabViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetJobVC) name:@"resetJobVC" object:nil];
    self.extendedLayoutIncludesOpaqueBars = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetJobVC" object:nil];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tbViewModel = [TBTabViewModel new];
    }
    return self;
}
-(void)RTTabDidPushIndex:(int)index{
    [self.tabBar selectedWithIndex:0];
    [self swichViewWithIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //当城市为空时才开始请求gprs数据
    self.locationManager = [[CLLocationManager alloc] init] ;
    self.locationManager.delegate = self;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if (version.floatValue >= 8.f)
    {
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    [self.locationManager startUpdatingLocation];
    RTTabItem *aItem = [RTTabItem new];
    aItem.title = @"";
    aItem.imageNormal = [UIImage imageNamed:@"toolbar_recommend"];
    aItem.imageHighted = [UIImage imageNamed:@"toolbar_recommend_selected"];
    RTTabItem *bItem = [RTTabItem new];
    bItem.title = @"";
    bItem.imageNormal = [UIImage imageNamed:@"toolbar_graph"];
    bItem.imageHighted = [UIImage imageNamed:@"toolbar_graph_selected"];
    RTTabItem *cItem = [RTTabItem new];
    cItem.title = @"";
    cItem.imageNormal = [UIImage imageNamed:@"toolbar_search"];
    cItem.imageHighted = [UIImage imageNamed:@"toolbar_search_selected"];
    RTTabItem *dItem = [RTTabItem new];
    dItem.title = @"";
    dItem.imageNormal = [UIImage imageNamed:@"toolbar_user"];
    dItem.imageHighted = [UIImage imageNamed:@"toolbar_user_selected"];
    CGFloat tabHeight = 98.0 / 2.0;
    if ( CP_IS_IPHONE_6P )
        tabHeight = 55.0;
    self.tabBar = [[RTTabView alloc] initWithFrame:CGRectMake( 0, self.view.viewHeight - tabHeight, self.view.viewWidth, tabHeight)];
    self.tabBar.customChange = YES;
    self.tabBar.titles = @[aItem, bItem, cItem, dItem];
    self.tabBar.collectionView.backgroundColor = [[RTAPPUIHelper shareInstance] darkGrayColor];
    self.tabBar.imageBackground = TKRoundedCornerImage( CGSizeMake(self.view.viewWidth / 3.0, tabHeight ), TKRoundedCornerNone, TKDrawnBorderSidesRight|TKDrawnBorderSidesTop, [[RTAPPUIHelper shareInstance] backgroundColor], [[RTAPPUIHelper shareInstance] lineColor], 0.5, 0);
    self.tabBar.imageHightedBackground = TKRoundedCornerImage(CGSizeMake(self.view.viewWidth / 3.0, tabHeight), TKRoundedCornerNone, TKDrawnBorderSidesRight|TKDrawnBorderSidesTop, [[RTAPPUIHelper shareInstance] backgroundColor], [[RTAPPUIHelper shareInstance] lineColor], 0.5, 0);
    [self.view addSubview:self.tabBar];
    __weak typeof(self) weakSelf = self;
    self.tabBar.selectedObject = ^void(NSInteger index){
        [weakSelf swichViewWithIndex:index];
    };
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.left.equalTo(self.view.mas_left);
        maker.right.equalTo(self.view.mas_right).offset(0);
        maker.bottom.equalTo(self.view.mas_bottom);
        maker.height.equalTo( @( tabHeight ) );
    }];
    [self.tabBar selectedWithIndex:0];
    JobSearchVC *jVC = [JobSearchVC new];
    self.direction = TabViewDirectionBottom;
    self.isTitleFollowSubController = YES;
    DynamicExamVC *eVc = [[DynamicExamVC alloc]initWithType:examTwo];
    MeVC *mVc = [MeVC new];
    mVc.tabDelegate = self;
    self.rVc = [RecommendVC new];
    self.rVc.isTranslate = self.isTranslate;
    [self setSwitchViewControllers:@[self.rVc,eVc,jVC,mVc]];
}
-(void)doCepin
{
    self.alertView.hidden = YES;
    NSString *url = [NSString stringWithFormat:@"%@/examcenter/desc?id=2",kHostMUrl];
    DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:url examDetail:examDetailOther];
    vc.title = @"极速职业测评";
    vc.strTitle = @"极速职业测评";
    vc.urlPath = url;
    vc.isJiSuCepin = YES;
    vc.urlLogo = @"http://file.cepin.com/da/speadexam_480_262.png";
    vc.contentText = @"你是否处于职业困惑中，不知道自己适合干什么？或者总觉得对现在的工作不感兴趣，毫无动力？再或者面临职业发展和转型，犹豫着何去何从？极速职业测评基于大五人格理论，可以帮助你深入了解自己的性格特点和脸谱类型、评估个人的能力水平和优劣势，并根据你的性格与能力帮助你找到最适合的岗位和企业。超过1000万测评者亲证，绝对duang duang的！为确保结果能真实反映你的水平，请：在安静、独立的空间完成测评根据第一反应答题如遇网络问题，退出后可以重新进入答题界面";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)resetJobVC
{
    [self.tabBar selectedWithIndex:0];
    [self swichViewWithIndex:0];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if(currentCityName && ![@"" isEqualToString:currentCityName]){
            return;
        }
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city)
            {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            currentCityName = city;
            if ([currentCityName hasSuffix:@"省"] || [currentCityName hasSuffix:@"市"] || [currentCityName hasSuffix:@"县"])
            {
                currentCityName = [currentCityName substringToIndex:currentCityName.length - 1];
            }
            RTLog(@"......city name : %@",currentCityName);
            RTLog(@"......subLocality name : %@",placemark.subLocality);
        }
        else
        {
            currentCityName = @"";
        }
        [[NSUserDefaults standardUserDefaults] setObject:currentCityName forKey:@"LocationCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)
    {
        //提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}
@end
