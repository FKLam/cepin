//
//  ResumeCompanyAddressSecondVM.m
//  cepin
//
//  Created by dujincai on 15/8/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyAddressSecondVM.h"
#import "RegionDTO.h"
@implementation ResumeCompanyAddressSecondVM
-(instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities
{
    if (self = [super init])
    {
        self.selectedCity = selectedCities;
        self.cities = cities;
    }
    return self;
}


-(BOOL)selectedCityWithIndex:(NSInteger)index
{
    Region *item = self.cities[index];
    
    if (self.selectedCity.count < 1)
    {
        [self.selectedCity addObject:item];
        return YES;
    }
    Region *tempItem = nil;
    
    for (Region *i in self.selectedCity)
    {
        if ([i.RegionName isEqualToString:item.RegionName]) {
            tempItem = i;
            break;
        }
    }
    
    if (tempItem)
    {
        [self.selectedCity removeObject:tempItem];
        return NO;
    }
    else
    {
        if (self.selectedCity.count < 3)
        {
            [self.selectedCity addObject:item];
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return NO;
}
@end
