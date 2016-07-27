//
//  CPTestEnsureArrowCell.h
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPArrowTextField.h"

@interface CPTestEnsureArrowCell : UITableViewCell

@property (nonatomic, strong) CPArrowTextField *inputTextField;
+ (instancetype)ensureArrowCellWithTableView:(UITableView *)tableView;

- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder;
- (void)resetSeparatorLineShowAll:(BOOL)showAll;
@end
