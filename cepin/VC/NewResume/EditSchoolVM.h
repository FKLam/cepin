//
//  EditSchoolVM.h
//  cepin
//
//  Created by dujincai on 15/8/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface EditSchoolVM : BaseRVMViewModel
@property(nonatomic,strong)NSMutableArray *selectSchool;
@property(nonatomic,strong)NSMutableArray *schools;
-(instancetype)initWithselectedSchool:(NSString *)selectedSchool;
@end
