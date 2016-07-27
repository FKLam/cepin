//
//  CPSchoolResumeEditController.h
//  cepin
//
//  Created by ceping on 16/1/29.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@class CPSchoolResumeEditController;
@protocol CPSchoolResumeEditControllerDelegate <NSObject>
@optional
- (void)schoolResumeEdit:(CPSchoolResumeEditController *)schoolResumeEdit deliveryResume:(ResumeNameModel *)deliveryResume;
@end
@interface CPSchoolResumeEditController : BaseTableViewController
@property (nonatomic, weak) id<CPSchoolResumeEditControllerDelegate> schoolResumeEditDelegate;
@property(nonatomic,strong)id SendResumeStateCode;
- (instancetype)initWithResumeId:(NSString*)resumeId;
- (instancetype)initWithResumeId:(NSString*)resumeId JobId:(NSString*)jobId;
- (instancetype)initWithResumeModel:(ResumeNameModel*)resumeModel;
- (instancetype)initWithResumeId:(NSString *)resumeId deliveryString:(NSString *)deliveryString;
@end
