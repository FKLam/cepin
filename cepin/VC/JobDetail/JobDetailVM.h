//
//  JobDetailVM.h
//  cepin
//
//  Created by ricky.tang on 14-10-31.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "JobDetailModelDTO.h"

@interface JobDetailVM : BaseRVMViewModel

@property(nonatomic,strong)NSString *jobId;
@property(nonatomic,strong)id getResumeStatecode;
@property(nonatomic,strong)id SendResumeStateCode;
@property(nonatomic,strong)NSString *sendMessage;
@property(nonatomic,strong)JobDetailModelDTO *data;
@property(nonatomic,strong)NSMutableArray *allResumes;
@property(nonatomic,strong)NSNumber *resumeType;

@property(nonatomic,retain)NSString *chooseResumeId;

-(instancetype)initWithJobId:(NSString *)jobId ResumeType:(NSNumber*)resumeType;
-(void)getPositionDetail;

-(void)sendResume;
-(void)getResume;

@end
