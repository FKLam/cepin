//
//  JobAddressVM.m
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobAddressVM.h"

@implementation JobAddressVM
-(instancetype)initWithJobModel:(SubscriptionJobModel *)model
{
    if (self = [super init])
    {
        self.hotAddress = [Region hotRegions];
        self.allAddress = [Region allRegions];
        self.selectedCity = [Region searchRegionWithAddressString:model.address];
        if (!self.selectedCity)
        {
            self.selectedCity = [NSMutableArray new];
        }
        
        self.GPSCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCity"];
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

@end
