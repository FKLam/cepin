//
//  TBTabViewModel.h
//  cepin
//
//  Created by dujincai on 15/9/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface TBTabViewModel : BaseRVMViewModel

@property(nonatomic,strong) NSString *version;
@property(nonatomic,assign)BOOL isExam;
@property(nonatomic,strong)id isExamStateCode;

- (void)checkVersion;
- (void)checkHasCepin;
@end
