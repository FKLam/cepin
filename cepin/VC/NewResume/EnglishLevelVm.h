//
//  EnglishLevelVm.h
//  cepin
//
//  Created by dujincai on 15/11/16.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface EnglishLevelVm : BaseRVMViewModel
@property (nonatomic, strong) UIViewController *showMessageVC;
- (void)saveEnglishLevel:(ResumeNameModel*)model;

@end
