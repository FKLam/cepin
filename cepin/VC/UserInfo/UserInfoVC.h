//
//  UserInfoVC.h
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserInfoVM.h"
@class UserInfoVC;
@protocol UserInfoVCDelegate <NSObject>
@optional
- (void)userInfoVCDidFinishEditing;
@end
@interface UserInfoVC : BaseTableViewController
@property (nonatomic, weak) id<UserInfoVCDelegate> userInfoVCDelegate;
@end
