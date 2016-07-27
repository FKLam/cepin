//
//  BaseMapViewController.m
//  yanyunew
//
//  Created by Ricky Tang on 14-5-1.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "BaseMapViewController.h"


#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface BaseMapViewController ()

@end

@implementation BaseMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && self.view.window == nil) {
        self.mapView = nil;
    }
}


-(void)createMap
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, ((IS_IPHONE_5)?568:480)-44-20)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}



-(void)openNavicationMapWithCurrentLocation:(CLLocationCoordinate2D)currentLocation targetLocation:(CLLocationCoordinate2D)targetLocation
{
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        //6.0以下，调用googleMap
        //注意经纬度不要写反了
        NSString * loadString=[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",currentLocation.latitude,currentLocation.longitude,targetLocation.latitude, currentLocation.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:loadString]];
        
    }
    else{
        //调用自带地图（定位）
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        //显示目的地坐标。画路线
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:targetLocation addressDictionary:nil]];
        
        //toLocation.name = self.shopNameStirng;
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:
                                      [NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving,
                                       [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
}

@end
