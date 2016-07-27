//
//  CPSearchCityFilterCell.h
//  cepin
//
//  Created by dujincai on 16/2/24.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSearchCityFilterCell : UITableViewCell
@property (nonatomic, strong) UILabel *cityFilterTitleLabel;

+ (instancetype)searchCityFilterCellWithTableView:(UITableView *)tableView;

- (void)configWithSearchCityFilterTitle:(NSString *)searchFilterTitle hideSelectedImage:(BOOL)hideSelectedImage;
-(void)resetLineWithShowFull:(BOOL)show;
@end
