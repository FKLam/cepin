//
//  CPHomeRecommendCell.h
//  cepin
//
//  Created by ceping on 16/1/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPHomeRecommendCell;
@protocol CPHomeRecommendCellDelegate <NSObject>
@optional
- (void)homeRecommendCell:(CPHomeRecommendCell *)homeRecommendCell clickedButton:(UIButton *)clickedButton;
@end
@interface CPHomeRecommendCell : UITableViewCell
@property (nonatomic, weak) id <CPHomeRecommendCellDelegate> homeRecommendCellDelegate;
+ (instancetype)homeRecommendCellWithTableView:(UITableView *)tableView;
- (void)configWithDataArray:(NSArray *)DataArray next:(NSUInteger)next;
@end
