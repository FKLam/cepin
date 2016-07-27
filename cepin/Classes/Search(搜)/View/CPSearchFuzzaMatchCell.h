//
//  CPSearchFuzzaMatchCell.h
//  cepin
//
//  Created by dujincai on 16/3/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPSearchMatchDTO.h"

@interface CPSearchFuzzaMatchCell : UITableViewCell
+ (instancetype)searchHistoryCellWithTableView:(UITableView *)tableView;
- (void)configWithKeywordModel:(SearchMatch *)model matchText:(NSString*)matchText  hideSeparator:(BOOL)hideSeparator;
@end
