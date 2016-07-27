//
//  AutoLoginVM.h
//  cepin
//
//  Created by ceping on 14-11-26.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"

@interface AutoLoginVM : NSObject
{
}
@property (nonatomic, strong) id AllResumeStateCode;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) BOOL isShowLoading;
@property (nonatomic, strong) NSNumber *boolNumber;
@property (nonatomic, strong) NSString *mobiel;
@property (nonatomic, strong) UserLoginDTO *login;
@property (nonatomic, strong) UIViewController *showMessageVC;
-(void)autoLogin;
@end
