//
//  NewJobDetialVC.h
//  cepin
//
//  Created by dujincai on 15/5/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "JobDetailModelDTO.h"

@interface NewJobDetialVC : BaseTableViewController
@property(nonatomic,retain)NSString    *logo;
@property(nonatomic,retain)NSNumber    *changeState;
-(instancetype)initWithJobId:(NSString *)jobId companyId:(NSString *)comanyId pstType:(NSNumber*)pstType;

@end
