//
//  ModifyEmailVM.h
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface ModifyEmailVM : BaseRVMViewModel
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) id checkAvailabelEmail;
@property (nonatomic, strong) id sendBindEmail;
@property (nonatomic, strong) NSNumber *availabelEmail;
@property (nonatomic, strong) NSString *sendBindEmailMessage;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (void)editEmailInfo;
- (void)checkEmailAvailabel;
- (void)sendBindEmailInfo;
@end
