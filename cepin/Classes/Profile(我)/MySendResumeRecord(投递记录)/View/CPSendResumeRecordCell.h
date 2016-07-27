//
//  CPSendResumeRecordCell.h
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendReumeModel.h"

@interface CPSendResumeRecordCell : UITableViewCell
+ (instancetype)sendResumeRecordCellWithTableView:(UITableView *)tableView;

- (void)configCellWithResumeRecord:(SendReumeModel *)resumeRecord;
@end
