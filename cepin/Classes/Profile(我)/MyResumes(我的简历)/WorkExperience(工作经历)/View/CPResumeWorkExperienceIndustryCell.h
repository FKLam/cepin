//
//  CPResumeWorkExperienceIndustryCell.h
//  cepin
//
//  Created by ceping on 16/2/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCodeDTO.h"
@class CPResumeWorkExperienceIndustryCell;
@protocol CPResumeWorkExperienceIndustryCellDelegate <NSObject>
@optional
- (void)workExperienceCell:(CPResumeWorkExperienceIndustryCell *)workExperienceCell didSelectedBasecode:(BaseCode *)selectedBaseode;
@end
@interface CPResumeWorkExperienceIndustryCell : UITableViewCell
+ (instancetype)workExperienceIndustryCellWithTableView:(UITableView *)tableView;
- (void)configWithTitle:(NSString *)titleStr childArray:(NSMutableArray *)childArray isSelected:(BOOL)isSelected selectedBaseode:(BaseCode *)selectedBaseode;
@property (nonatomic, weak) id<CPResumeWorkExperienceIndustryCellDelegate> workExperienceDelegate;
@end
