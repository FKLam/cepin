//
//  CPNFreePasswordLoginVm.h
//  cepin
//
//  Created by ceping on 16/7/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface CPNFreePasswordLoginVm : BaseRVMViewModel
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) id mobialStateCode;
@property (nonatomic, strong) id freeLoginStateCode;
@property (nonatomic, strong) id getUserInfoStateCode;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *mobileCode;
@property (nonatomic, assign) BOOL isSendMobileValid;
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (nonatomic, strong) UserLoginDTO *login;

- (void)getMobileValidateSms;
- (void)exemptPasswordLogin;
@end
