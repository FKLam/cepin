//
//  BaseFullCell.h
//  cepin
//
//  Created by dujincai on 15-4-23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullResumeDataModel.h"
#import "CPCommon.h"

@interface BaseFullCell : UITableViewCell
@property (nonatomic, strong) UIView *baseSeparatorView;

- (void)createCellWithModel:(id)model height:(int)height;
//传模型
- (void)createCellWithModel:(id)model;

//时间
- (NSString *)managestrTime:(NSString *)time;

- (void)desWithOut:(BOOL)none;

- (void)getModel:(id)model;
@end
