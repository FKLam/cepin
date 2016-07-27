//
//  CPPraciticeLeaderCell.h
//  cepin
//
//  Created by ceping on 16/1/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@interface CPPraciticeLeaderCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;
+ (instancetype)studentLeaderCellWithTableView:(UITableView *)tableView;
- (void)configCellWithStudentLeader:(StudentLeadersDataModel *)studentLeader;
@end
