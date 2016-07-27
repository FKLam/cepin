//
//  EditLanguageVM.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface EditLanguageVM : BaseRVMViewModel
@property(nonatomic,strong)id saveStateCode;
@property(nonatomic,strong)LanguageDataModel *langData;
@property(nonatomic,strong)NSString *langId;
@property(nonatomic,strong)NSString *resumeId;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithWork:(LanguageDataModel*)model;
- (void)saveLanguage;
@end
