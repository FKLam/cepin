//
//  CPMyTestInviteCell.h
//  cepin
//
//  Created by ceping on 16/1/16.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicExamModelDTO.h"

@interface CPMyTestInviteCell : UITableViewCell
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *testButton;
+ (instancetype)myTestInviteCellWithTableView:(UITableView *)tableView;
+ (instancetype)myPositionCellWithTableView:(UITableView *)tableView;

- (void)configCellWithExamModel:(DynamicExamModelDTO *)examModel;

@end
