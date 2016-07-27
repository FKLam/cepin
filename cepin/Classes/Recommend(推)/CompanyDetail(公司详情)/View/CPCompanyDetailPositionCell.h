//
//  CPCompanyDetailPositionCell.h
//  cepin
//
//  Created by ceping on 16/1/27.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRecommendModelFrame.h"
@class CPCompanyDetailPositionCell;
@protocol CPCompanyDetailPositionCellDelegate <NSObject>
@optional
- (void)companyDetailPositionCell:(CPCompanyDetailPositionCell *)companyDetailPositionCell clickedLoadMoreButton:(UIButton *)loadMoreButton;
@end
@interface CPCompanyDetailPositionCell : UITableViewCell
@property (nonatomic, weak) id<CPCompanyDetailPositionCellDelegate> companyDetailPositionCellDelegate;
@property (nonatomic, strong) JobSearchModel *recommendModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
+ (instancetype)guessCellWithTableView:(UITableView *)tableView;
- (void)configCellWithDatas:(CPRecommendModelFrame *)modelFrame;
- (void)setContentIsRead:(BOOL)isRead;
- (void)setLastCellIsHide:(BOOL)isHide;
@end
