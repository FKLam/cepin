//
//  ResumeCompanyJobNameVM.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface ResumeCompanyJobNameVM : BaseRVMViewModel
@property(nonatomic,strong)NSMutableArray *JobFirstData;
@property (nonatomic, assign, getter = isOpened) BOOL opened;//开 关

@end
