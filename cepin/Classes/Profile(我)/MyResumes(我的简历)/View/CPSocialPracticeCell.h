//
//  CPSocialPracticeCell.h
//  cepin
//
//  Created by ceping on 16/1/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"

@interface CPSocialPracticeCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;

+ (instancetype)socialPracticeCellWithTableView:(UITableView *)tableView;

- (void)configCellWithPractice:(PracticeListDataModel *)practice;
@end