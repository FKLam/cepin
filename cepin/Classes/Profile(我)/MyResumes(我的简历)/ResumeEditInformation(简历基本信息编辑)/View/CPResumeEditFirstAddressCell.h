//
//  CPResumeEditFirstAddressCell.h
//  cepin
//
//  Created by ceping on 16/2/23.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegionDTO.h"
@class CPResumeEditFirstAddressCell;
@protocol CPResumeEditFirstAddressCellDelegate <NSObject>
@optional
- (void)resumeEditFirstAddressCell:(CPResumeEditFirstAddressCell *)resumeEditFirstAddressCell didSelectedRegion:(Region *)selectedRegion;
- (void)resumeEditFirstAddressCell:(CPResumeEditFirstAddressCell *)resumeEditFirstAddressCell didSelectedRegion:(Region *)selectedRegion isCanAdd:(BOOL)isCanAdd;
@end
@interface CPResumeEditFirstAddressCell : UITableViewCell
+ (instancetype)editFirstAddressCellWithTableView:(UITableView *)tableView;
- (void)configWithTitle:(NSString *)titleStr childArray:(NSMutableArray *)childArray isSelected:(BOOL)isSelected selectedRegion:(Region *)selectedRegion;
- (void)configWithTitle:(NSString *)titleStr childArray:(NSMutableArray *)childArray isSelected:(BOOL)isSelected selectedRegions:(NSMutableArray *)selectedRegions;
@property (nonatomic, weak) id<CPResumeEditFirstAddressCellDelegate> editFirstAddressDelegate;
@end
