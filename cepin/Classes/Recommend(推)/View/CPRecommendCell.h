//
//  CPRecommendCell.h
//  cepin
//
//  Created by ceping on 15/11/19.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPRecommendModelFrame;

@interface CPRecommendCell : UITableViewCell

/** 职位模型数据框架 */
@property (nonatomic, strong) CPRecommendModelFrame *recommendModelFrame;

/**
 *  创建一个cell
 *
 *  @param tableView 展示cell容器的视图
 */
+ (instancetype)recommendCellWithTableView:(UITableView *)tableView;

- (void)draw;

- (void)clear;

@end
