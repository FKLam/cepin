//
//  RegionDTO.h
//  cepin
//
//  Created by ricky.tang on 14-10-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "BaseBeanModel.h"
/**
 *  RegionId	Int	地区编号
 Level	Int	地区层级
 PathCode	String	地区code
 Hot	Int	是否热门地区
 SortCode	String	地区编码
 RegionName	String	地区名称
 RegionFullName	String	地区全部名称
 */

@protocol Region

@end

@interface Region : BaseBeanModel
@property(nonatomic,strong)NSNumber<Optional> *RegionId;
@property(nonatomic,strong)NSNumber<Optional> *Level;
@property(nonatomic,strong)NSString<Optional> *PathCode;
@property(nonatomic,strong)NSNumber<Optional> *Hot;
@property(nonatomic,strong)NSString<Optional> *SortCode;
@property(nonatomic,strong)NSString<Optional> *RegionName;
@property(nonatomic,strong)NSString<Optional> *RegionFullName;
@property(nonatomic,strong)NSString<Optional> *firstLetter;


+(NSMutableArray *)hotRegions;

+(NSMutableArray *)allRegions;

+(NSMutableArray *)citiesWithRegionId:(NSNumber *)regionId;

+(NSMutableArray *)citiesWithCodePath:(NSString *)codePath;

+(NSMutableArray *)citiesWithCodeAndNotHot:(NSString*)codePath;

+(NSMutableArray*)searchAddressWithAddressPathCodeString:(NSString*)pathCodeString;

+(Region*)searchAddressWithAddressString:(NSString*)pathCodeString;

+(Region*)searchAddressWithPathCode:(NSString*)pathCode;

+(NSMutableArray*)searchRegionWithAddressString:(NSString*)pathCodeString;

+(NSMutableArray *)searchRegionWithRegionName:(NSString*)name;
+ (NSMutableArray *)allThirdLevelRegion;
@end
