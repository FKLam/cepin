//
//  CPTrainExperienceCell.h
//  cepin
//
//  Created by ceping on 16/1/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"

@interface CPTrainExperienceCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;

+ (instancetype)trainCellWithTableView:(UITableView *)tableView;

- (void)configCellWithtrain:(TrainingDataModel *)train;
@end
