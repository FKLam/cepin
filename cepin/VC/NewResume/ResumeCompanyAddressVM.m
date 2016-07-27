//
//  ResumeCompanyAddressVM.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyAddressVM.h"
#import <CoreLocation/CoreLocation.h>
@interface ResumeCompanyAddressVM ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
@implementation ResumeCompanyAddressVM
-(instancetype)initWithWorkModel:(WorkListDateModel *)model
{
    if (self = [super init])
    {
        self.allAddress = [Region allRegions];
        self.hotAddress = [Region hotRegions];
        self.selectedCity = [Region searchRegionWithAddressString:model.JobCity];
        if (!self.selectedCity)
        {
            self.selectedCity = [NSMutableArray new];
        }
        self.GPSCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
    }
    return self;
}
- (void)beginLocation
{
    if ( [CLLocationManager locationServicesEnabled] == FALSE )
        return;
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}
-(NSMutableArray *)indexPathInHotAddress
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:3];
    
    [self.hotAddress enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        Region *c = (Region *)obj;
        [self.selectedCity enumerateObjectsUsingBlock:^(id item,NSUInteger indexb,BOOL *stop){
            Region *i = (Region *)item;
            if ([c.PathCode isEqualToString:i.PathCode]) {
                [temp addObject:[NSIndexPath indexPathForItem:index inSection:0]];
            }
            
        }];
    }];
    
    return temp;
}
-(void)selectedCityWithRegion:(Region *)value
{
    __block BOOL isHaseObject = NO;
    
    [self.selectedCity enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        Region *item = (Region *)obj;
        if ([value.PathCode isEqualToString:item.PathCode]) {
            isHaseObject = YES;
            *stop = YES;
        }
        
    }];
    
    if (!isHaseObject) {
        [self.selectedCity addObject:value];
    }
}
-(void)didDeselectCityWithRegion:(Region *)value
{
    __block BOOL isHaseObject = NO;
    __block NSUInteger i = 0;
    [self.selectedCity enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        Region *item = (Region *)obj;
        if ([value.PathCode isEqualToString:item.PathCode]) {
            isHaseObject = YES;
            i = index;
            *stop = YES;
        }
        
    }];
    
    if (isHaseObject) {
        [self.selectedCity removeObjectAtIndex:i];
    }
}
-(BOOL)isHasAddressInSelectedCityWithRegion:(Region *)value
{
    __block BOOL isHaseObject = NO;
    [self.selectedCity enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        Region *item = (Region *)obj;
        if ([value.PathCode isEqualToString:item.PathCode]) {
            isHaseObject = YES;
            *stop = YES;
        }
        
    }];
    
    return isHaseObject;
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [locations firstObject];
    __weak typeof( self ) weakSelf = self;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ( error )
        {
            weakSelf.GPSCity = @"无法定位";
        }
        if ( placemarks.count > 0 )
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *city = placemark.locality;
            if ( !city )
                city = placemark.administrativeArea;
            weakSelf.GPSCity = city;
        }
        if ( [weakSelf.addressChooseDelegate respondsToSelector:@selector(companyAddressChoose:locationCity:)] )
        {
            [weakSelf.addressChooseDelegate companyAddressChoose:self locationCity:weakSelf.GPSCity];
            [self.locationManager stopUpdatingLocation];
        }
    }];
}
- (CLLocationManager *)locationManager
{
    if ( !_locationManager )
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        if ( [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] )
        {
            [_locationManager requestWhenInUseAuthorization];
//            [_locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}
@end
