//
//  ResumeCompanyAddressVM.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "RegionDTO.h"
#import "ResumeNameModel.h"
@class ResumeCompanyAddressVM;
@protocol ResumeCompanyAddressVMDelegate <NSObject>
@optional
- (void)companyAddressChoose:(ResumeCompanyAddressVM *)addressChoose locationCity:(NSString *)locationCity;
@end
@interface ResumeCompanyAddressVM : BaseRVMViewModel
@property(nonatomic,retain)NSMutableArray *datas;
@property(nonatomic,retain)NSMutableArray *hotAddress;
@property(nonatomic,retain)NSMutableArray *allAddress;
@property(nonatomic,retain)NSMutableArray *selectedCity;
@property(nonatomic,strong)NSString *GPSCity;
@property (nonatomic, weak) id<ResumeCompanyAddressVMDelegate> addressChooseDelegate;
-(instancetype)initWithWorkModel:(WorkListDateModel *)model;
-(NSMutableArray *)indexPathInHotAddress;
-(void)selectedCityWithRegion:(Region *)value;
-(void)didDeselectCityWithRegion:(Region *)value;
-(BOOL)isHasAddressInSelectedCityWithRegion:(Region *)value;
- (void)beginLocation;
@end
