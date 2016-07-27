//
//  JobAddressSecondVM.h
//  cepin
//
//  Created by dujincai on 15/8/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface JobAddressSecondVM : BaseRVMViewModel
@property(nonatomic,weak)NSMutableArray *selectedCity;
@property(nonatomic,strong)NSArray *cities;

-(instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities;

-(BOOL)selectedCityWithIndex:(NSInteger)index;
@end
