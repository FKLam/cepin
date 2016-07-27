//
//  JobModelDTO.h
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"

@interface JobModelDTO : JSONModel

@property(nonatomic,strong)NSString<Optional> *PositionName;
@property(nonatomic,strong)NSString<Optional> *PositionId;
@property(nonatomic,strong)NSString<Optional> *PositionNature;
@property(nonatomic,strong)NSString<Optional> *City;
@property(nonatomic,strong)NSString<Optional> *Salary;
@property(nonatomic,strong)NSString<Optional> *CompanyName;
@property(nonatomic,strong)NSString<Optional> *CustomerId;
@property(nonatomic,strong)NSString<Optional> *Logo;
@property(nonatomic,strong)NSString<Optional> *PublishDate;
@property(nonatomic,strong)NSNumber<Optional> *IsDeliveried;
@property(nonatomic,strong)NSNumber<Optional> *IsCollection;

+(JobModelDTO*)beanFromDictionary:(NSDictionary*)dic;

@end
