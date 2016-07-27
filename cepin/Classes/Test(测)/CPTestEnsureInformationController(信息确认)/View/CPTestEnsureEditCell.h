//
//  CPTestEnsureEditCell.h
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTestEnsureTextFiled.h"

typedef NS_ENUM(NSUInteger , CPTestEnsureEditTag)
{
    CPTestEnsureEditMaxTag = 100,
    CPTestEnsureEditEmailTag = 101
};

@interface CPTestEnsureEditCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) CPTestEnsureTextFiled *inputTextField;
+ (instancetype)ensureEditCellWithTableView:(UITableView *)tableView;
- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder;
- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder editButton:(UIButton *)editButton;
- (void)resetSeparatorLineShowAll:(BOOL)showAll;
@end
