//
//  ResumeCompanyNatureVM.h
//  cepin
//
//  Created by dujincai on 15/8/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface ResumeCompanyNatureVM : BaseRVMViewModel
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)NSMutableArray *selection;
-(instancetype)initWithSelected:(NSString *)selected;

@end
