//
//  ExpectFunctionSecondVM.h
//  cepin
//
//  Created by dujincai on 15/6/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//
#import "BaseRVMViewModel.h"

@interface ExpectFunctionSecondVM : BaseRVMViewModel
@property(nonatomic,strong)NSMutableArray *selectedObject;
@property(nonatomic,strong)NSMutableArray *datas;
-(instancetype)initWithData:(NSMutableArray *)data seletedData:(NSMutableArray *)seletedData;

-(BOOL)selectedCityWithIndex:(NSInteger)index;
@end
