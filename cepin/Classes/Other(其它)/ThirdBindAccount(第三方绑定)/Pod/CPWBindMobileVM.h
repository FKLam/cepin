//
//  CPWBindMobileVM.h
//  cepin
//
//  Created by ceping on 16/4/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
@interface CPWBindMobileVM : BaseRVMViewModel
@property (nonatomic, strong) id mobileStateCode;
@property (strong, nonatomic) NSString *mobileString;
@property (strong, nonatomic)  NSString *mobileCodeString;
@property (nonatomic, strong) NSString *passwordString;
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) BOOL isSendMobileValid;
- (void)getMobileValidateSms;
- (void)emailBAccountindMobile;
@end
