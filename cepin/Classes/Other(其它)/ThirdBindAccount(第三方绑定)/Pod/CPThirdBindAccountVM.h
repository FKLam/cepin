//
//  CPThirdBindAccountVM.h
//  cepin
//
//  Created by ceping on 16/3/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "UserLoginDTO.h"
@interface CPThirdBindAccountVM : BaseRVMViewModel
//账号
@property (strong, nonatomic) NSString *account;
//验证码
@property (strong, nonatomic)  NSString *mobialCode;
@property (nonatomic, strong) id mobialStateCode;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *loginName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *mobile;
@property (assign, nonatomic) int comeFrom;
@property (assign,nonatomic)  BOOL isSelectPro;
@property (assign,nonatomic)  BOOL isKeyBoardShow;
@property (nonatomic, strong) UserLoginDTO *userData;
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (nonatomic, assign) BOOL isSendMobileValid;
@property (nonatomic, strong) NSMutableArray *allResumeArrayM;
-(void)registerUser;
- (void)getMobileValidateSms;
@end
