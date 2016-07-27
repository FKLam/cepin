//
//  CPProfilePositionRecommendCell.h
//  cepin
//
//  Created by ceping on 16/3/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPJobRecommendModel.h"
@interface CPProfilePositionRecommendCell : UITableViewCell
@property (nonatomic, strong) UIButton *cllectionButton;
+ (instancetype)positionRecommendCellWithTableView:(UITableView *)tableView;
- (void)configCellWithRecommendJob:(CPJobRecommendModel *)recommendJobModel;
@end
