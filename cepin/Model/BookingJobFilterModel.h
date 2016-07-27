//
//  BookingJobFilterModel.h
//  cepin
//  上床本地的工作订阅，
//  Created by Ricky Tang on 14-11-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobFilterModel.h"
#import "SubscriptionJobModelDTO.h"

@interface BookingJobFilterModel : JobFilterModel

@property(nonatomic,strong)NSMutableArray<BaseCode> *industries;//行业
@property(nonatomic,strong)NSMutableArray<BaseCode> *jobFunctions;//工作职能
@property(nonatomic,strong)NSMutableArray<BaseCode> *companyNature;//公司性质
@property(nonatomic,strong)NSMutableArray<BaseCode> *companySize;//公司规模

-(void)reloadWithFileName:(NSString*)fieName;
-(BOOL)saveObjectToDiskWithFile:(NSString*)fieName;
-(BOOL)deleteObjectFromDisk:(NSString*)fileName;
-(void)deleteObjectFromNet:(NSString*)fileName;
-(void)deleteJobSearch:(NSString*)fileName;
-(void)resetWithModelAndFileName:(SubscriptionJobModelDTO*)bean file:(NSString*)fileName;

@end
