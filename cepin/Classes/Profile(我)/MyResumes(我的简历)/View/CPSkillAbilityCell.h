//
//  CPSkillAbilityCell.h
//  cepin
//
//  Created by ceping on 16/1/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@interface CPSkillAbilityCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;
+ (instancetype)skillCellWithTableView:(UITableView *)tableView;
- (void)configCellWithSkill:(SkillDataModel *)skill;
@end
