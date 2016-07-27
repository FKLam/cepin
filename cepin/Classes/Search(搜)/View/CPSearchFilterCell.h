//
//  CPSearchFilterCell.h
//  cepin
//
//  Created by ceping on 16/1/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSearchFilterCell : UITableViewCell
@property (nonatomic, strong) UILabel *filterTitleLabel;

+ (instancetype)searchFilterCellWithTableView:(UITableView *)tableView;

- (void)configWithSearchFilterTitle:(NSString *)searchFilterTitle hideSelectedImage:(BOOL)hideSelectedImage;

@end
