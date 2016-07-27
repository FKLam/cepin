//
//  AddressChooseHuKouVM.h
//  cepin
//
//  Created by dujincai on 15/6/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "RegionDTO.h"
#import "ResumeNameModel.h"
@class AddressChooseHuKouVM;
@protocol AddressChooseHuKouVMDelegate <NSObject>
@optional
- (void)addressChooseHuKouVM:(AddressChooseHuKouVM *)addressChooseHuKou locationCity:(NSString *)locationCity;
@end
@interface AddressChooseHuKouVM : BaseRVMViewModel
@property(nonatomic,strong)NSString *GPSCity;
@property(nonatomic,retain)NSMutableArray *datas;
@property(nonatomic,retain)NSMutableArray *hotAddress;
@property(nonatomic,retain)NSMutableArray *allAddress;
@property(nonatomic,retain)NSMutableArray *selectedCity;
@property (nonatomic, weak) id<AddressChooseHuKouVMDelegate> addressChooseHuKouDelegate;
@property(nonatomic,weak)ResumeNameModel *sendmodel;

-(instancetype)initWithSendModel:(ResumeNameModel*)model;
- (void)beginLocation;
-(NSMutableArray *)indexPathInHotAddress;
-(void)selectedCityWithRegion:(Region *)value;
-(void)didDeselectCityWithRegion:(Region *)value;
-(BOOL)isHasAddressInSelectedCityWithRegion:(Region *)value;
@end
