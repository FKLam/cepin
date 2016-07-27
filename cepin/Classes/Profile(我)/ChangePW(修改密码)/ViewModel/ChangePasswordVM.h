//
//  ChangePasswordVM.h
//  cepin
//
//  Created by dujincai on 15/7/1.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface ChangePasswordVM : BaseRVMViewModel
@property(nonatomic,strong)NSString*passWord;
@property(nonatomic,strong)NSString*oldPassword;
@property(nonatomic,strong)NSString *entenPassword;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (void)changePassword;
- (BOOL)canSubmit;
@end
