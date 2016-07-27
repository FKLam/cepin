//
//  EditMajorVM.h
//  cepin
//
//  Created by dujincai on 15/8/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface EditMajorVM : BaseRVMViewModel
@property(nonatomic,strong)NSMutableArray *selectMajor;
@property(nonatomic,strong)NSMutableArray *majors;
-(instancetype)initWithselectedMajor:(NSString *)selectedmajor;
@end
