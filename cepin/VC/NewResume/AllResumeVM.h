//
//  AllResumeVM.h
//  cepin
//
//  Created by ceping on 15-3-16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AllResumeVM : BaseRVMViewModel
@property(nonatomic,retain)id  toTopStateCode;
@property(nonatomic,retain)id  deleteStateCode;
@property(nonatomic,retain)id  cpStateCode;
@property(nonatomic,retain)id  AddStateCode;
@property(nonatomic,assign)NSUInteger currentIndex;
@property(nonatomic,assign)BOOL showLoad;
@property(nonatomic,retain)NSMutableArray *datas;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)ResumeNameModel *resumeModel;
@property(nonatomic,strong)ResumeNameModel *cpresumeModel;
@property (nonatomic, strong) UIViewController *showMessageVC;
-(void)getAllResume;
-(void)toTop;
-(void)deleteResume;
-(void)copyResume;

- (void)addThridResume;

@end
