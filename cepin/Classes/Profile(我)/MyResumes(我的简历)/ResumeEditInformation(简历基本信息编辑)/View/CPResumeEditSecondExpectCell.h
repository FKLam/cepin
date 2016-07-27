//
//  CPResumeEditSecondExpectCell.h
//  cepin
//
//  Created by ceping on 16/2/24.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCodeDTO.h"
@class CPResumeEditSecondExpectCell;
@protocol CPResumeEditSecondExpectCellDelegate <NSObject>
@optional
- (void)editSecondExpectCell:(CPResumeEditSecondExpectCell *)editSecondExpectCell selecetdBaseCode:(BaseCode *)selecetdBaseCode isAdd:(BOOL)isAdd;
@end
@interface CPResumeEditSecondExpectCell : UITableViewCell
@property (nonatomic, weak) id <CPResumeEditSecondExpectCellDelegate> editSecondExpectCellDelegate;
+ (instancetype)editSecondExpectCellWithTableView:(UITableView *)tableView;
- (void)configWithTitle:(NSString *)titleStr childArray:(NSMutableArray *)childArray isSelected:(BOOL)isSelected selectedRegions:(NSMutableArray *)selectedRegions;
- (void)changeContenTableWidth:(CGFloat)tableWidth;
@end
