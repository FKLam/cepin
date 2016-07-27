//
//  JobFunctionSecondVM.h
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "BaseCodeDTO.h"

@interface JobFunctionSecondVM : BaseRVMViewModel
@property(nonatomic,strong)NSMutableArray *selectedObject;
@property(nonatomic,strong)NSMutableArray *jobFunctionsKey;
@property(nonatomic,strong)NSMutableArray *datas;
- (instancetype)initWithData:(NSMutableArray *)data seletedData:(NSMutableArray *)seletedData jobFunctionsKey:(NSMutableArray*)jobFunctionskey;
-(BOOL)selectedCityWithIndex:(NSInteger)index;
@end
