//
//  SignupGuideResumeVM.h
//  cepin
//
//  Created by dujincai on 15/7/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface SignupGuideResumeVM : BaseRVMViewModel
@property (nonatomic,strong) NSArray *jobStatusArray;
@property (nonatomic,strong) ResumeNameModel *resumeNameModel;
@property (nonatomic,retain) NSArray *GenderStringArray;
@property (nonatomic,retain) NSArray *MaritalStringArray;
@property (nonatomic,strong) id updateImageStateCode;
@property (nonatomic, strong) id checkAvailabelEmail;
@property (nonatomic, strong) id sendBindEmail;
@property (nonatomic, strong) NSNumber *availabelEmail;
@property (nonatomic, strong) NSString *sendBindEmailMessage;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (NSString*)genderString;
- (void)saveThridEditionResume;
- (void)uploadResumeHeadImageWithImage:(UIImage *)image;
- (void)checkEmailAvailabel;
- (void)sendBindEmailInfo;
@end
