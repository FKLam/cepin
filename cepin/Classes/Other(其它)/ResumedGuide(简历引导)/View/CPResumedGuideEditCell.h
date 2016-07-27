//
//  CPResumedGuideEditCell.h
//  cepin
//
//  Created by ceping on 16/1/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTestEnsureTextFiled.h"
@class CPResumedGuideEditCell;

@protocol CPResumedGuideEditCellDelegate <NSObject>

@optional
- (void)guideEditCell:(CPResumedGuideEditCell *)guideEditCell beginEditEmail:(UITextField *)emailEditTextField;
- (void)guideEditCell:(CPResumedGuideEditCell *)guideEditCell endEdit:(UITextField *)emailEditTextField;

@end

@interface CPResumedGuideEditCell : UITableViewCell

+ (instancetype)ensureEditCellWithTableView:(UITableView *)tableView;
- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder;

@property (nonatomic, strong) CPTestEnsureTextFiled *inputTextField;
@property (nonatomic, weak) id<CPResumedGuideEditCellDelegate> resumedGuideEditCellDelegate;

@end
