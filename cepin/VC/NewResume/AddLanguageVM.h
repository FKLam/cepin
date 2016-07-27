//
//  AddLanguageVM.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddLanguageVM : BaseRVMViewModel
@property(nonatomic,strong)LanguageDataModel *langData;
@property(nonatomic,strong)NSString *resumeId;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeid:(NSString*)resumeid;
- (void)addLanguage;
@end
