//
//  CompanyDetailVM.h
//  cepin
//
//  Created by ceping on 14-12-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "CompanyDetailModelDTO.h"
#import "PositionIdModel.h"

@interface CompanyDetailVM : BaseRVMViewModel

@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong)CompanyDetailModelDTO *data;
@property(nonatomic,assign)BOOL     isOpen;
@property(nonatomic,assign)BOOL     isLoad;
@property(nonatomic,retain)id  deleteStateCode;
@property(nonatomic,retain)id  saveStateCode;
@property(nonatomic, strong)NSMutableArray *positionIdArray;

-(instancetype)initWithCompanyId:(NSString *)cId;
-(void)getCompanyDetail;
-(void)deleteCompany;
-(void)saveCompany;

- (void)allPositionId;

@end
