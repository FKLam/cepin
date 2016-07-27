//
//  BaseMapViewController.h
//  yanyunew
//
//  Created by Ricky Tang on 14-5-1.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
@interface BaseMapViewController : BaseViewController<MKMapViewDelegate>
@property(nonatomic,strong) MKMapView *mapView;

-(void)createMap;

-(void)openNavicationMapWithCurrentLocation:(CLLocationCoordinate2D)currentLocation targetLocation:(CLLocationCoordinate2D)targetLocation;
@end
