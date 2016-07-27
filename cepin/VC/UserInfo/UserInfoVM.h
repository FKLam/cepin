//
//  UserInfoVM.h
//  cepin
//
//  Created by Ricky Tang on 14-11-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "AFHTTPRequestOperationManager.h"
@class UserLoginDTO;
@interface UserInfoVM : BaseRVMViewModel
@property(nonatomic,strong)NSString *realName;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)id updateImageStateCode;
@property(nonatomic,strong)id editUserInfoStateCode;
@property (nonatomic, strong) UIImage *tempImage;
@property(nonatomic,strong)UserInfoDTO *data;
@property(nonatomic,strong)NSString *friendUserId;
@property(nonatomic,retain)UserInfoDTO *editSendModel;
@property(nonatomic,retain)AFHTTPRequestOperationManager *uploadManager;
@property (nonatomic, strong) UIViewController *showMessageVC;
//上传图片
-(void)uploadUserHeadImageWithImage:(UIImage *)imageLogo;
//获取个人信息
-(void)userInfomation;
//修改个人信息
- (void)editUserInfo;
@end
