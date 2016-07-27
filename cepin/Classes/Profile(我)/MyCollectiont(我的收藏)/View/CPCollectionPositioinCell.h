//
//  CPCollectionPositioinCell.h
//  cepin
//
//  Created by ceping on 16/1/16.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobSearchModel.h"
@interface CPCollectionPositioinCell : UITableViewCell
+ (instancetype)collectionPositionCellWithTableView:(UITableView *)tableView;
- (void)configCellWithSaveJob:(JobSearchModel *)saveJobModel;
@property (nonatomic, strong) UIButton *cllectionButton;
@end
