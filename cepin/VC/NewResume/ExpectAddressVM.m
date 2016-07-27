//
//  ExpectAddressVM.m
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExpectAddressVM.h"
#import <CoreLocation/CoreLocation.h>
#import "CPPinyin.h"
#import "CPChineseString.h"
@interface ExpectAddressVM ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
@implementation ExpectAddressVM
-(instancetype)initWithSendModel:(ResumeNameModel*)model
{
    if (self = [super init])
    {
        self.isShrink = NO;
        self.hotAddress = [Region hotRegions];
        self.sendmodel = model;
        self.selectedCity = [NSMutableArray new];
        [self.selectedCity removeAllObjects];
        if ([model.ExpectCity isEqualToString:@""] || !model.ExpectCity)
        {
            [self.selectedCity removeAllObjects];
        }
        else
        {
            self.selectedCity = [NSMutableArray arrayWithArray:[model.ExpectCity componentsSeparatedByString:@","]];
            for ( NSString *city in self.selectedCity )
            {
                if ( 0 == [city length] )
                {
                    [self.selectedCity removeObject:city];
                    break;
                }
            }
        }
        self.GPSCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
        NSMutableArray *allAddress = [Region allRegions];
        //字母排序
        //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
        for( int i = 0; i < [allAddress count]; i++ )
        {
            CPChineseString *chineseString=[[CPChineseString alloc]init];
            Region *region = [allAddress objectAtIndex:i];
            chineseString.string=[NSString stringWithString:region.RegionName];
            if( chineseString.string == nil )
            {
                chineseString.string = @"";
            }
            if( ![chineseString.string isEqualToString:@""] )
            {
                NSString *pinYinResult = [NSString string];
                for( int j = 0; j<chineseString.string.length; j++ )
                {
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseString.pinYin = pinYinResult;
            }
            else
            {
                chineseString.pinYin=@"";
            }
            region.firstLetter = chineseString.pinYin;
        }
        NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES]];
        NSArray *sortedArr = [allAddress sortedArrayUsingDescriptors:sortDesc];
        self.allAddress = [NSMutableArray arrayWithArray:sortedArr];
    }
    return self;
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
- (BOOL)isHasAddressInSelectedCityWithRegion:(Region *)value
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
- (void)beginLocation
{
    if ( [CLLocationManager locationServicesEnabled] == FALSE )
        return;
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
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
        if ( [weakSelf.expectAddressChooseDelegate respondsToSelector:@selector(expectAddressChoose:locationCity:)] )
        {
            [weakSelf.expectAddressChooseDelegate expectAddressChoose:weakSelf locationCity:weakSelf.GPSCity];
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
