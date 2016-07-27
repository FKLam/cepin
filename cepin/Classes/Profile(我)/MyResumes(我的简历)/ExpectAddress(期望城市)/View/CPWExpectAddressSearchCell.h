//
//  CPWExpectAddressSearchCell.h
//  cepin
//
//  Created by ceping on 16/3/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPWExpectAddressSearchCell : UITableViewCell
+ (instancetype)searchMatchCellWithTableView:(UITableView *)tableView;

- (void)configSearchMatchCell:(NSString *)searchMatchTitle matchString:(NSString *)matchStrin hideSeparator:(BOOL)hideSeparator isSelected:(BOOL)isSelected;
@end
