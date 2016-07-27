//
//  MeVM.h
//  cepin
//
//  Created by dujincai on 15/6/6.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "UserInfoDTO.h"
#import "AutoLoginVM.h"
@interface MeVM : BaseRVMViewModel
@property(nonatomic,assign)BOOL isLoad;
@property (nonatomic, strong) id getChangeUserStateCode;
@property(nonatomic,strong)UserInfoDTO *data;
@property(nonatomic,strong)AutoLoginVM *autoVm;
@property (nonatomic, strong) UIImage *tempImage;
@property(nonatomic,strong)UIViewController *showMessageVC;

//获取个人信息
-(void)userInfomation;
- (void)getChangeUserInfor;
@end
