//
//  CPWResumeEditInfoIDCardCell.h
//  cepin
//
//  Created by ceping on 16/4/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTestEnsureTextFiled.h"
@interface CPWResumeEditInfoIDCardCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) CPTestEnsureTextFiled *inputTextField;
+ (instancetype)ensureEditCellWithTableView:(UITableView *)tableView;
- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder;
- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder editButton:(UIButton *)editButton;
- (void)resetSeparatorLineShowAll:(BOOL)showAll;
@end
