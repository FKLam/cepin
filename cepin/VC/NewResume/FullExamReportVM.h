//
//  FullExamReportVM.h
//  cepin
//
//  Created by dujincai on 15/7/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "DynamicExamModelDTO.h"

@interface FullExamReportVM : BaseRVMViewModel
@property(nonatomic,strong)NSMutableArray *datas;
- (void)getExamReport;
@end
