//
//  ResumeNameVC.h
//  cepin
//
//  Created by dujincai on 15/6/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@class ResumeNameVC;
@protocol ResumeNameVCDelegate <NSObject>
@optional
- (void)socialResumeEdit:(ResumeNameVC *)socialResumeEdit deliveryResume:(ResumeNameModel *)deliveryResume;
@end
@interface ResumeNameVC : BaseTableViewController
@property (nonatomic, weak) id<ResumeNameVCDelegate>socialResumeEditDelegate;
@property(nonatomic,strong)id SendResumeStateCode;
- (instancetype)initWithResumeId:(NSString*)resumeId;
- (instancetype)initWithResumeId:(NSString*)resumeId JobId:(NSString*)jobId;
- (instancetype)initWithResumeModel:(ResumeNameModel*)resumeModel;
- (instancetype)initWithResumeId:(NSString *)resumeId deliveryString:(NSString *)deliveryString;
@end
