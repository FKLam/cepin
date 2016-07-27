//
//  CPSearchHistoryCell.h
//  cepin
//
//  Created by kun on 16/1/8.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeywordModel.h"

@interface CPSearchHistoryCell : UITableViewCell

+ (instancetype)searchHistoryCellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) UIButton *historyDeleteButton;
@property(nonatomic,strong)UIButton *deleteView;

- (void)configWithKeywordModel:(KeywordModel *)model hideSeparator:(BOOL)hideSeparator;

@end
