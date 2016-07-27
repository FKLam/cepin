//
//  CPWorkExperienceCell.h
//  cepin
//
//  Created by ceping on 16/1/17.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"

@interface CPWorkExperienceCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;
+ (instancetype)workExperienceCellWithTableView:(UITableView *)tableView;
- (void)configCellWithWorkExperience:(WorkListDateModel *)workExperience resume:(ResumeNameModel *)resume;
@end
