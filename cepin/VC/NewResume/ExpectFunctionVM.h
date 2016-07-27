//
//  ExpectFunctionVM.h
//  cepin
//
//  Created by dujincai on 15/6/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface ExpectFunctionVM : BaseRVMViewModel

@property(nonatomic,strong)NSString *resumeJobFunction;
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)NSMutableArray *jobFunctions;
@property(nonatomic)BOOL isShrink;
@property (nonatomic, assign, getter = isOpened) BOOL opened;//开 关
-(instancetype)initWithResumeModel:(ResumeNameModel*)model;
@end

