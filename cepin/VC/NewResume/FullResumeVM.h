//
//  FullResumeVM.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "AllResumeDataModel.h"
#import "FullResumeDataModel.h"
#import "ResumeNameModel.h"
#import "BaseCodeDTO.h"
@interface FullResumeVM : BaseRVMViewModel
@property(nonatomic,strong)ResumeNameModel *data;
//@property(nonatomic,retain)FullResumeDataModel *data;
@property(nonatomic,retain)id  toTopStateCode;
@property(nonatomic,retain)id  deleteStateCode;
@property(nonatomic,strong)id  reportStateCode;
@property(nonatomic,strong)NSString *resumeId;
@property(nonatomic,strong)NSMutableArray *reportDatas;
@property (nonatomic, strong) NSMutableArray *workYearArrayM;
-(instancetype)initWithResumeId:(NSString*)resumeId;
-(void)getFullResumeDetail;
-(void)toTop;
-(void)deleteResume;
- (void)getExamReport;
@end
