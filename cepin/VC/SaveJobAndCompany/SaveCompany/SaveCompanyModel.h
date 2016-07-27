//
//  SaveCompanyModel.h
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"

@interface SaveCompanyModel : JSONModel

@property(nonatomic,strong)NSString<Optional> *CompanyName;
@property(nonatomic,strong)NSString<Optional> *CustomerId;
@property(nonatomic,strong)NSString<Optional> *CompanyLogo;
@property(nonatomic,strong)NSString<Optional> *CompanySize;
@property(nonatomic,strong)NSString<Optional> *CompanyNature;
@property(nonatomic,strong)NSString<Optional> *IndustryName;

+(SaveCompanyModel*)beanFromDictionary:(NSDictionary*)dic;

@end
