//
//  ExpectAddressVM.h
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "RegionDTO.h"
#import "ResumeNameModel.h"
@class ExpectAddressVM;
@protocol ExpectAddressChooseVMDelegate <NSObject>
@optional
- (void)expectAddressChoose:(ExpectAddressVM *)expectAddressChoose locationCity:(NSString *)locationCity;
@end
@interface ExpectAddressVM : BaseRVMViewModel
@property (nonatomic, strong) NSString *GPSCity;
@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic, retain) NSMutableArray *hotAddress;
@property (nonatomic, retain) NSMutableArray *allAddress;
@property (nonatomic, retain) NSMutableArray *selectedCity;
@property (nonatomic, assign) BOOL isShrink;
@property (nonatomic, strong) ResumeNameModel *sendmodel;
@property (nonatomic, weak) id<ExpectAddressChooseVMDelegate> expectAddressChooseDelegate;

-(instancetype)initWithSendModel:(ResumeNameModel*)model;
- (void)beginLocation;
-(NSMutableArray *)indexPathInHotAddress;
-(void)selectedCityWithRegion:(Region *)value;
-(void)didDeselectCityWithRegion:(Region *)value;
-(BOOL)isHasAddressInSelectedCityWithRegion:(Region *)value;
@end
