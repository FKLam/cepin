//
//  NewJobDetialVM.h
//  cepin
//
//  Created by dujincai on 15/5/20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "JobDetailModelDTO.h"
#import "CompanyDetailModelDTO.h"
#import "PositionIdModel.h"
#import "JobSearchModel.h"
#import "CPPositionDetailCacheReformer.h"
#import "ResumeNameModel.h"
@interface NewJobDetialVM : BaseRVMViewModel
@property (nonatomic, assign) BOOL isLoad;
@property(nonatomic,strong)id collectionJobStateCode;
@property(nonatomic,strong)id deleteJobStateCode;
@property(nonatomic,strong)id saveCompanyStateCode;
@property(nonatomic,strong)id deleteCompanyStateCode;
@property (nonatomic, strong) id deliveryResumeStateCode;
@property(nonatomic,strong)JobDetailModelDTO *data;
@property(nonatomic,strong)CompanyDetailModelDTO *companyData;
@property (nonatomic, strong) NSDictionary *companyDict;
@property(nonatomic,strong)NSString *jobId;
@property(nonatomic,strong)NSString *companyId;
@property (nonatomic, strong) NSDictionary *positionDetail;
@property (nonatomic, strong) NSMutableArray *resumeArrayM;
@property (nonatomic,strong)NSString *message;
@property (nonatomic, assign) BOOL isSuccessGetAllResume;
@property (nonatomic, strong) NSMutableArray *positionIdArray;

-(instancetype)initWithJobId:(NSString *)jobId companyId:(NSString *)comanyId;
-(void)collectionJob;
-(void)deleteJob;
-(void)getPositionDetail;
-(void)getCompanyDetail;
-(void)deleteCompany;
-(void)saveCompany;
- (void)resumeDeliveryWithResumeID:(NSString *)resumeID;
- (void)getAllResumeWithPositionType:(NSNumber *)positionType;
- (void)allPositionId;
- (void)regetAllResumeWithPositionType:(NSNumber *)positionType;
@end
