//
//  CPHomeGuessCell.h
//  cepin
//
//  Created by ceping on 16/1/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRecommendModelFrame.h"
@class CPHomeGuessCell;
@protocol CPHomeGuessCellDelegate <NSObject>
@optional
- (void)homeGuessCell:(CPHomeGuessCell *)homeGuessCell clickedLoadMoreButton:(UIButton *)loadMoreButton;
@end
@interface CPHomeGuessCell : UITableViewCell
@property (nonatomic, weak) id <CPHomeGuessCellDelegate>homeGuessCellDelegate;
@property (nonatomic, strong) JobSearchModel *recommendModel;
@property (nonatomic, strong) UIButton *cllectionButton;
@property (nonatomic, strong) NSIndexPath *indexPath;
+ (instancetype)guessCellWithTableView:(UITableView *)tableView;

- (void)configCellWithDatas:(CPRecommendModelFrame *)modelFrame hideCheckMoreButton:(BOOL)hideChekMoreButton;
- (void)configCellWithDatas:(CPRecommendModelFrame *)modelFrame highlightText:(NSString*)text isRead:(BOOL)isRead;
- (void)setSeparatorIsHide:(BOOL)isHide;
- (void)setContentIsRead:(BOOL)isRead;
- (void)setLastCellIsHide:(BOOL)isHide;
@end
