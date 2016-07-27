//
//  SendReumeModel.h
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"

@interface SendReumeModel : JSONModel

@property(nonatomic,strong)NSString<Optional> *PositionName;
@property(nonatomic,strong)NSString<Optional> *PositionId;
@property(nonatomic,strong)NSString<Optional> *PositionNature;
@property(nonatomic,strong)NSString<Optional> *Address;
@property(nonatomic,strong)NSString<Optional> *Salary;
@property(nonatomic,strong)NSString<Optional> *CompanyName;
@property(nonatomic,strong)NSString<Optional> *CustomerId;
@property(nonatomic,strong)NSString<Optional> *PublishDate;
@property(nonatomic,strong)NSString<Optional> *ApplyDate;
@property(nonatomic,strong)NSNumber<Optional> *Viewed;
@property(nonatomic,strong)NSString<Optional> *ViewedDate;
@property(nonatomic,strong)NSNumber<Optional> *PositionType;//简历类型


+(SendReumeModel*)beanFromDictionary:(NSDictionary*)dic;

@end
