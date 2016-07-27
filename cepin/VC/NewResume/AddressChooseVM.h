//
//  AddressChooseVM.h
//  cepin
//
//  Created by ceping on 15-3-19.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "RegionDTO.h"
#import "ResumeNameModel.h"
@class AddressChooseVM;
@protocol AddressChooseVMDelegate <NSObject>
@optional
- (void)addressChoose:(AddressChooseVM *)addressChoose locationCity:(NSString *)locationCity;
@end
@interface AddressChooseVM : BaseRVMViewModel
@property(nonatomic,strong)NSString *GPSCity;
@property(nonatomic,retain)NSMutableArray *datas;
@property(nonatomic,retain)NSMutableArray *hotAddress;
@property(nonatomic,retain)NSMutableArray *allAddress;
@property(nonatomic,retain)NSMutableArray *selectedCity;

@property(nonatomic,weak)ResumeNameModel *sendmodel;
@property (nonatomic, weak) id<AddressChooseVMDelegate> addressChooseDelegate;
-(instancetype)initWithSendModel:(ResumeNameModel*)model;

-(NSMutableArray *)indexPathInHotAddress;
-(void)selectedCityWithRegion:(Region *)value;
-(void)didDeselectCityWithRegion:(Region *)value;
-(BOOL)isHasAddressInSelectedCityWithRegion:(Region *)value;
- (void)beginLocation;
@end
