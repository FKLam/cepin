//
//  CPSearchMatchCell.h
//  cepin
//
//  Created by kun on 16/1/9.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSearchMatchCell : UITableViewCell

+ (instancetype)searchMatchCellWithTableView:(UITableView *)tableView;

- (void)configSearchMatchCell:(NSString *)searchMatchTitle matchString:(NSString *)matchStrin hideSeparator:(BOOL)hideSeparator;
@end
