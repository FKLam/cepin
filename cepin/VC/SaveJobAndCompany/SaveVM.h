//
//  SaveVM.h
//  cepin
//
//  Created by dujincai on 15/6/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "SaveJobDTO.h"
#import "SaveCompanyModel.h"
@interface SaveVM : BaseTableViewModel
@property(nonatomic,retain)id deleteJobStateCode;
@property(nonatomic,retain)NSMutableArray *selectJobs;
@property(nonatomic,strong)id deleteSaveCompany;
@property(nonatomic,strong)NSMutableArray *selectedCompanies;

-(void)deleteJobs;
-(void)cancelSavecompany;
@end
