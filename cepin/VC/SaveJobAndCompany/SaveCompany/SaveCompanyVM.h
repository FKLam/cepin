//
//  SaveCompanyVM.h
//  cepin
//
//  Created by Ricky Tang on 14-11-4.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "CompanyTableObject.h"

@interface SaveCompanyVM : BaseTableViewModel

@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,strong)id deleteSaveCompany;
@property(nonatomic,strong)NSMutableArray *selectedCompanies;
-(BOOL)selectedWithIndex:(NSInteger)index;


-(void)cancelSavecompany;

@end
