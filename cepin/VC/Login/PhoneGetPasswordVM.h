//
//  PhoneGetPasswordVM.h
//  cepin
//
//  Created by dujincai on 15/5/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface PhoneGetPasswordVM : BaseRVMViewModel
@property(nonatomic,strong)NSString *account;
@property(nonatomic,strong)id mobialStateCode;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *enterPassword;
@property(nonatomic,strong)NSString *validateCode;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithAccount:(NSString*)account;

- (void)getMobileSms;

- (void)saveNewPassword;

@end
