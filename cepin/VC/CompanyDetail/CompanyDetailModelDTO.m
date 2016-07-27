//
//  CompanyDetailModelDTO.m
//  cepin
//
//  Created by ceping on 14-12-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CompanyDetailModelDTO.h"

@implementation CompanyPositionModel
@end

@implementation CompanyFairModel
@end


@implementation CompanyEnvironmentModel
@end


@implementation CompanyDetailModelDTO

+(CompanyDetailModelDTO*)beanFromDictionary:(NSDictionary*)dic
{
    NSError *error = nil;
    CompanyDetailModelDTO *bean = [[CompanyDetailModelDTO alloc] initWithDictionary:dic error:&error];
    NSAssert(error == nil, @"SendReumeModel fail");
    
    return bean;
}

-(void)memoryRelease
{
    self.CustomerId = nil;
    self.CompanyName = nil;
    self.Logo = nil;
    self.Introduction = nil;
    self.Address = nil;
    self.CompanySize = nil;
    self.CompanyNature = nil;
    self.IsListedCompany = nil;
    self.Industry = nil;
    self.Description = nil;
    self.IsCollection = nil;
    self.AppPositionInfoList = nil;
    self.AppCampusFairList = nil;
    self.AppEnvironmentList = nil;
}

@end
