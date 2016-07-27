//
//  CPResumeEditInforOneWordController.h
//  cepin
//
//  Created by ceping on 16/1/29.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface CPResumeEditInforOneWordController : BaseTableViewController
- (instancetype)initWithModelId:(NSString *)resumeId defaultDes:(NSString*)des;
- (instancetype)initWithModelId:(NSString *)resumeId showRightTitle:(BOOL)show;
@end
