//
//  CPEducationExperienceCell.h
//  cepin
//
//  Created by ceping on 16/1/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"

@interface CPEducationExperienceCell : UITableViewCell

@property (nonatomic, strong) UIButton *editButton;

+ (instancetype)educationExperienceCellWithTableView:(UITableView *)tableView;

- (void)configCellWithEducationExperience:(EducationListDateModel *)educationExperience;

@end
