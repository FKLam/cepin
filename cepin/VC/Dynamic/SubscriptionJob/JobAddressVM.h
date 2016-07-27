//
//  JobAddressVM.h
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "RegionDTO.h"
#import "SubscriptionJobModel.h"
@interface JobAddressVM : BaseRVMViewModel
@property(nonatomic,strong)NSString *GPSCity;
@property(nonatomic,retain)NSMutableArray *datas;
@property(nonatomic,retain)NSMutableArray *hotAddress;
@property(nonatomic,retain)NSMutableArray *allAddress;
@property(nonatomic,retain)NSMutableArray *selectedCity;

- (instancetype)initWithJobModel:(SubscriptionJobModel *)model;

-(NSMutableArray *)indexPathInHotAddress;
-(void)selectedCityWithRegion:(Region *)value;
-(void)didDeselectCityWithRegion:(Region *)value;
-(BOOL)isHasAddressInSelectedCityWithRegion:(Region *)value;
@end
