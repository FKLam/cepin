//
//  AddThridEditionResumeVM.h
//  cepin
//
//  Created by dujincai on 15/6/13.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddThridEditionResumeVM : BaseRVMViewModel
@property(nonatomic,strong)ResumeNameModel *resumeNameModel;
@property(nonatomic,retain) NSArray *GenderStringArray;
@property(nonatomic,retain) NSArray *MaritalStringArray;
@property(nonatomic,retain)id updateImageStateCode;
@property(nonatomic,strong) UIImageView  *headImage;
@property(nonatomic,strong) NSArray *jobStatusArray;
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (nonatomic, strong) NSString *resumeName;
@property (nonatomic, strong) id changeResumeNameEditStateCode;
@property (nonatomic, strong) id changeResumeNameStateCode;
@property (nonatomic, strong) NSMutableArray *workYearkArrayM;
-(NSString*)maritalString;
-(NSString*)genderString;
- (BOOL)request;
-(void)uploadUserHeadImageWithImage:(UIImage *)imageLogo;
- (void)saveThridEditionResume;
- (void)creteResumeWithResume:(int)ResumeType;
- (void)getResumeInfo;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;
- (instancetype)initWithResumeModelId:(NSString*)modelId;
- (void)editBaseInfo:(NSString *)resumedId;
- (void)saveBackEditBaseInfo:(NSString *)resumedId;
// 上传新简历头像
-(void)uploadCreateResumeHeadImageWithImage:(UIImage *)imageLogo;
@end
