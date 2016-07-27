//
//  DynamicExamVM.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "DynamicExamModelDTO.h"
@interface DynamicExamVM : BaseTableViewModel
@property(nonatomic,strong)UIImage *images;
@property(nonatomic,strong)TBLoading *load;
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,assign)BOOL isCompany;//判断是否是企业消息
@end
