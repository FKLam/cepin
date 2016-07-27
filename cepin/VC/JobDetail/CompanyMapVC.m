//
//  CompanyMapVC.m
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CompanyMapVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface CompanyMapVC ()
@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,strong)CLGeocoder *geocoder;
@property(nonatomic,strong)NSString   *address;
@end

@implementation CompanyMapVC

-(instancetype)initWithAddress:(NSString *)address
{
    self = [super init];
    if (self) {
        self.address = address;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址";
    self.geocoder = [[CLGeocoder alloc]init];
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, IsIOS7?64:44, self.view.viewWidth, self.view.viewHeight)];
    [self.view addSubview:self.mapView];
    //设置地图可放缩
    self.mapView.zoomEnabled = YES;
    //设置地图滚动
    self.mapView.scrollEnabled = YES;
    //设置地图不可旋转
    self.mapView.rotateEnabled = NO;
    //显示当前位置
    self.mapView.userInteractionEnabled = YES;
    [self locateWithAddress];
}

- (void)locateWithAddress
{
    [self.geocoder geocodeAddressString:self.address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]>0 && error == nil) {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            
            //设置显示地图范围
            MKCoordinateSpan span;
            //地图显示范围越小，细节越清楚
            span.longitudeDelta = 0.01;
            span.latitudeDelta = 0.01;
            
            MKCoordinateRegion region = {placeMark.location.coordinate,span};
            //设置地图中心位置搜索到的位置
            [self.mapView setRegion:region];
            
            //创建一个地图描点
            MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
            //设置地图描点的坐标
            point.coordinate = placeMark.location.coordinate;
            //设置地图描点的标题
            point.title = self.address;
            
            [self.mapView addAnnotation:point];
            //选中描点
            [self.mapView selectAnnotation:point animated:YES];
            
        }else
        {
            // [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            [OMGToast showWithText:@"没有找到位置" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
