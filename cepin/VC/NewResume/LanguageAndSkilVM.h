//
//  LanguageAndSkilVM.h
//  cepin
//
//  Created by dujincai on 15/7/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface LanguageAndSkilVM : BaseRVMViewModel
@property(nonatomic,strong)ResumeNameModel *resumeModel;

@property(nonatomic,strong)NSString *resumeId;
- (instancetype)initWithResumeId:(NSString*)resumeId;

- (void)getResumeInfo;
@end
