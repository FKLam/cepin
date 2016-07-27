//
//  SaveJobVM.h
//  cepin
//  收藏职位
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "SaveJobDTO.h"
//#import "JobDefine.h"

@interface SaveJobVM : BaseTableViewModel

@property(nonatomic,retain)id deleteJobStateCode;
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,retain)NSMutableArray *selectJobs;

-(BOOL)selectedWithIndex:(NSInteger)index;

-(void)deleteJobs;

@end
