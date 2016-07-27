//
//  ForgetPasswordVM.h
//  cepin
//
//  Created by ricky.tang on 14-10-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface ForgetPasswordVM : BaseRVMViewModel
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (strong, nonatomic) NSString *account;

-(void)getPasswordFromSever:(int)forgotType;

@end
