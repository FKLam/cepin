//
//  SignupVM.h
//  cepin
//
//  Created by ricky.tang on 14-10-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface SignupVM : BaseRVMViewModel
//账号
@property (strong, nonatomic)NSString *account;
//验证码
@property (strong, nonatomic)  NSString *mobialCode;
@property (nonatomic, strong) id mobialStateCode;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *loginName;
@property (strong, nonatomic) NSString *password;
@property (nonatomic, strong) NSString *enterpassword;
@property (strong, nonatomic) NSString *mobile;
@property (assign, nonatomic) int comeFrom;
@property (assign,nonatomic)  BOOL isSelectPro;
@property (assign,nonatomic)  BOOL isKeyBoardShow;
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (nonatomic, assign) BOOL isSendMobileValid;
-(void)registerUser;
- (void)getMobileValidateSms;
@end
