//
//  AddDescriptionVM.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddDescriptionVM : BaseRVMViewModel
@property(nonatomic,strong)ResumeNameModel *resumeModel;
@property(nonatomic,strong)NSString *resumeId;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;
/** 保存自我描述 */
- (void)saveInfo;
/** 保存一句话优势 */
- (void)saveOneWord;
@end
