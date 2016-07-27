//
//  CPResumeInforAddressMatchCityCell.h
//  cepin
//
//  Created by ceping on 16/3/6.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "RegionDTO.h"
@interface CPResumeInforAddressMatchCityCell : UITableViewCell
+ (instancetype)searchMatchCellWithTableView:(UITableView *)tableView;
- (void)configSearchMatchCell:(Region *)region matchString:(NSString *)matchString hideSeparator:(BOOL)hideSeparator isSelected:(BOOL)isSelected;
@end
