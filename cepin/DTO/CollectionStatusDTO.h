//
//  CollectionStatusDTO.h
//  cepin
//
//  Created by ceping on 14-11-24.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"

@interface CollectionStatusDTO : JSONModel

@property(nonatomic,strong)NSNumber<Optional> *CollPositionStatus;
@property(nonatomic,strong)NSNumber<Optional> *ApplyPositionStatus;
@property(nonatomic,strong)NSNumber<Optional> *CollCompanyStatus;
@property(nonatomic,strong)NSNumber<Optional> *CollFairStatus;

@property(nonatomic,strong)NSNumber<Optional> *CollCompanyCount;
@property(nonatomic,strong)NSNumber<Optional> *ApplyPositionCount;
@property(nonatomic,strong)NSNumber<Optional> *CollPositionCount;
@property(nonatomic,strong)NSNumber<Optional> *CollFairCount;
@property(nonatomic,strong)NSNumber<Optional> *MessageUnReadCount;

+(CollectionStatusDTO *)userInfoWithDictionary:(NSDictionary *)dic;

@end
