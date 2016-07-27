//
//  CPResumeEducationSearchMatchCell.h
//  cepin
//
//  Created by ceping on 16/3/7.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolDTO.h"
#import "BaseCodeDTO.h"
@interface CPResumeEducationSearchMatchCell : UITableViewCell
+ (instancetype)educationSearchMatchCellWithTableView:(UITableView *)tableView;
- (void)configWithSchool:(School *)school isHideSeparatorLine:(BOOL)isHideSeparatorLine;
- (void)configWithMajor:(BaseCode *)major isHideSeparatorLine:(BOOL)isHideSeparatorLine;
@end
