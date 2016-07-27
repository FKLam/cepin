//
//  LoginVM.h
//  cepin
//
//  Created by ricky.tang on 14-10-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
@interface LoginVM : BaseRVMViewModel
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) id thirdPartLoginStateCode;
@property (nonatomic, strong) id AllResumeStateCode;
@property (nonatomic, strong) id mobialStateCode;
@property (nonatomic, strong) id freeLoginStateCode;
@property (nonatomic, strong) id getUserInfoStateCode;
@property (nonatomic, strong) NSString *thirdLoginName;
@property (nonatomic, strong) NSString *thirdLoginId;
@property (nonatomic, strong) NSString *thirdLoginType;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *mobileCode;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UserLoginDTO *login;
@property (nonatomic, strong) NSDictionary *userDataDict;
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (nonatomic, assign) BOOL isSendMobileValid;
- (void)Login;
- (void)thirdPartLogin;
- (void)getMobileValidateSms;
- (void)exemptPasswordLogin;
@end
