//
//  CPResumeEditThirdExpectCell.h
//  cepin
//
//  Created by ceping on 16/2/24.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCodeDTO.h"
@interface CPResumeEditThirdExpectCell : UITableViewCell
+ (instancetype)editThirdExpectCellWithTableView:(UITableView *)tableView;
- (void)configWithTitle:(NSString *)titleStr isSelected:(BOOL)isSelected;
@end
