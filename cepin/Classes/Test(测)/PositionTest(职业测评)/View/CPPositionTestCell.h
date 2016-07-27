//
//  CPPositionTestCell.h
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicExamModelDTO.h"

@interface CPPositionTestCell : UITableViewCell

+ (instancetype)positionTestCellWithTableView:(UITableView *)tableView;

- (void)configCellWithPostionTestModel:(DynamicExamModelDTO *)positionTestModel;

@end
