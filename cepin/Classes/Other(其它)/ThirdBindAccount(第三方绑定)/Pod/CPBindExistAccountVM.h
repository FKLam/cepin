//
//  CPBindExistAccountVM.h
//  cepin
//
//  Created by ceping on 16/3/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "UserLoginDTO.h"
@interface CPBindExistAccountVM : BaseRVMViewModel
//账号
@property (strong, nonatomic) NSString *account;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) id mobialStateCode;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *loginName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *mobile;
@property (assign,nonatomic)  BOOL isKeyBoardShow;
@property (nonatomic, strong) UserLoginDTO *userData;
@property (nonatomic, strong) UIViewController *setViewController;
@property (nonatomic, strong) NSMutableArray *allResumeArrayM;
-(void)bindUser;
@end
