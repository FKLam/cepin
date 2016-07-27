//
//  CPPraciticeAwardCell.h
//  cepin
//
//  Created by ceping on 16/1/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"

@interface CPPraciticeAwardCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;
+ (instancetype)awardCellWithTableView:(UITableView *)tableView;
- (void)configCellWithAward:(AwardsListDataModel *)award;
@end