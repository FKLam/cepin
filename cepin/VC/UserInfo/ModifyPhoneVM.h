//
//  ModifyPhoneVM.h
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
@class ModifyPhoneVM;
@protocol ModifyPhoneVMDelegate <NSObject>
@optional
- (void)modifyPhoneVMClickEnsureButtonWithCode:(NSInteger)changeStateCode;
@end
@interface ModifyPhoneVM : BaseRVMViewModel
@property (nonatomic, weak) id<ModifyPhoneVMDelegate> modifyPhoneVMDelegate;
@property(nonatomic,strong)id mobialStateCode;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *phoneCode;
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (nonatomic, assign) BOOL isSendMobileValid;
- (void)editPhoneInfo;
//获取验证码
- (void)getMobileSms;
@end
