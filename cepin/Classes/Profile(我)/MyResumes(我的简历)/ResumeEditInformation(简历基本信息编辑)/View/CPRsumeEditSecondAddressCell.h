//
//  CPRsumeEditSecondAddressCell.h
//  cepin
//
//  Created by ceping on 16/2/23.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPRsumeEditSecondAddressCell : UITableViewCell
+ (instancetype)editSecondAddressCellWithTableView:(UITableView *)tableView;
- (void)configWithTitle:(NSString *)titleStr isSelected:(BOOL)isSelected;
- (void)setIsLast:(BOOL)isLast;
@end
