//
//  CPProfileCompanyMessageCell.h
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicSystemModelDTO.h"

@interface CPProfileCompanyMessageCell : UITableViewCell
@property (nonatomic, strong) UILabel *testTitleLabel;
+ (instancetype)companyMessageCellWithTabelView:(UITableView *)tableView;
- (void)configeCellWith:(DynamicSystemModelDTO *)messageModel;

@end
