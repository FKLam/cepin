//
//  ResumeNameVM.h
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface ResumeNameVM : BaseRVMViewModel
@property(nonatomic,retain)id  toTopStateCode;
@property(nonatomic,retain)id  deleteStateCode;
@property(nonatomic,retain)id SendResumeStateCode;
@property (nonatomic, strong) id reportStateCode;
@property(nonatomic,strong) ResumeNameModel *resumeNameModel;
@property(nonatomic,assign)NSUInteger currentIndex;
@property(nonatomic,retain)NSMutableArray *datas;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSString *jobId;
@property(nonatomic,strong)NSString *message;
@property (nonatomic, strong) UIViewController *showMessageVC;
@property (nonatomic, strong) NSMutableArray *reportDatas;
- (instancetype)initWithResumeId:(NSString*)resumeId;
//上传图片
-(void)uploadUserHeadImageWithImage:(UIImage *)imageLogo;

- (void)getResumeInfo;
-(void)toTop;
-(void)sendResume;
-(void)deleteResume;
- (void)getExamReport;
@end
