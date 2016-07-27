//
//  LanguageVM.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface LanguageVM : BaseRVMViewModel
@property(nonatomic,strong)LanguageDataModel *langModel;
@property(nonatomic,strong)id  deleteCode;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSMutableArray *langDatas;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;
- (void)getLanguage;
- (void)dellteLanguage:(NSString*)languageId;
@end
