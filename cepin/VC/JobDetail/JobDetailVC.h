//
//  JobDetailVC.h
//  cepin
//
//  Created by ricky.tang on 14-10-31.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
//#import "JobModelDTO.h"

@interface JobDetailVC :BaseTableViewController

@property(nonatomic,retain)NSString    *logo;
@property(nonatomic,retain)NSNumber    *changeState;

-(instancetype)initWithJobId:(NSString *)jobId resumeType:(NSNumber*)resumeType;


@end
