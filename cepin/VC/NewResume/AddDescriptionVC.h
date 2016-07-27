//
//  AddDescriptionVC.h
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface AddDescriptionVC : BaseTableViewController
- (instancetype)initWithModelId:(NSString *)resumeId defaultDes:(NSString*)des;
- (instancetype)initWithModelId:(NSString *)resumeId showRightTitle:(BOOL)show;
- (instancetype)initWithModelId:(NSString *)resumeId showRightTitle:(BOOL)show comeFromString:(NSString *)comeFromString;
@end
