//
//  CPOtherLanguageCell.h
//  cepin
//
//  Created by ceping on 16/1/31.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@interface CPOtherLanguageCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;
+ (instancetype)languageCellWithTableView:(UITableView *)tableView;
- (void)configCellWithLanguage:(LanguageDataModel *)language;
@end
