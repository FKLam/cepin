//
//  CPResumeWorkExperienceSecondIndustryCell.h
//  cepin
//
//  Created by ceping on 16/2/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CPResumeWorkExperienceSecondIndustryCell : UITableViewCell
+ (instancetype)workExperienceCellWithTableView:(UITableView *)tableView;
- (void)configWithTitle:(NSString *)titleStr isSelected:(BOOL)isSelected;
@end
