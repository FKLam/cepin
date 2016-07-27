//
//  ResumeCompanyIndustryVM.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface ResumeCompanyIndustryVM : BaseRVMViewModel
@property(nonatomic,strong)NSMutableArray *industryData;
@property (nonatomic, assign, getter = isOpened) BOOL opened;//开 关
@end
