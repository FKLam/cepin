//
//  CPWatchResumeCell.h
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobSearchModel.h"

@interface CPWatchResumeCell : UITableViewCell

+ (instancetype)watchResumeCellWithTableView:(UITableView *)tableView;

- (void)configCellWithResume:(JobSearchModel *)model;

@end
