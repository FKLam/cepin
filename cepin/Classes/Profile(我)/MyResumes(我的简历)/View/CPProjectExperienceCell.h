//
//  CPProjectExperienceCell.h
//  cepin
//
//  Created by ceping on 16/1/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"

@interface CPProjectExperienceCell : UITableViewCell

@property (nonatomic, strong) UIButton *editButton;

+ (instancetype)projectExperienceCellWithTableView:(UITableView *)tableView;

- (void)configCellWithProjectExperience:(ProjectListDataModel *)projectExperience;

@end
