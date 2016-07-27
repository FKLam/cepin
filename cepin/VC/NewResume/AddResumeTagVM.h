//
//  AddResumeTagVM.h
//  cepin
//
//  Created by dujincai on 15/6/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddResumeTagVM : BaseRVMViewModel
@property(nonatomic,strong)NSMutableArray *tagArray;
@property(nonatomic,strong)NSString *keyWord;
@property(nonatomic,strong)ResumeNameModel *resumeModel;
- (void)addResumeTag;

- (instancetype)initWithResumeModel:(ResumeNameModel*)model;

@end
