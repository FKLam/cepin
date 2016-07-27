//
//  CPResumeEditFirstExpectCell.h
//  cepin
//
//  Created by ceping on 16/2/24.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCodeDTO.h"
@class CPResumeEditFirstExpectCell;
@protocol CPResumeEditFirstExpectCellDelegate <NSObject>
@optional
- (void)editFirstExpectCell:(CPResumeEditFirstExpectCell *)editFirstExpectCell changeHeight:(CGFloat)changeHeight selectedRow:(NSInteger)selectedRow;
- (void)editFirstExpectCell:(CPResumeEditFirstExpectCell *)editFirstExpectCell selecetdBaseCode:(BaseCode *)selecetdBaseCode isAdd:(BOOL)isAdd;
@end
@interface CPResumeEditFirstExpectCell : UITableViewCell
@property (nonatomic, weak) id<CPResumeEditFirstExpectCellDelegate> editFirstExpectCellDelegate;
+ (instancetype)editFirstExpectCellWithTableView:(UITableView *)tableView;
- (void)configWithTitle:(NSString *)titleStr firstChildArray:(NSMutableArray *)firstChildArray isSelected:(BOOL)isSelected selectedRegions:(NSMutableArray *)selectedRegions;
- (void)configWithTitle:(NSString *)titleStr firstChildArray:(NSMutableArray *)firstChildArray isSelected:(BOOL)isSelected selectedRegions:(NSMutableArray *)selectedRegions selectedSecondRow:(NSInteger)selectedSecondRow;
- (void)changeContenTableWidth:(CGFloat)tableWidth;
@end
