//
//  CPDeliveryResumeCell.h
//  cepin
//
//  Created by ceping on 16/3/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@interface CPDeliveryResumeCell : UITableViewCell
+ (instancetype)deliveryRsumeCellWithTableView:(UITableView *)tableView;
- (void)configDeliveryCellWithResume:(ResumeNameModel *)resume isSelected:(BOOL)isSelecetd;
- (void)hideSeparatorIsHide:(BOOL)isHide;
@end
