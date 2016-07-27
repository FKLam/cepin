//
//  ResumeSwitchCell.h
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumeSwitchCell : UITableViewCell
@property(nonatomic,strong)UIButton *Switchimage;
@property(nonatomic,strong)UIView *line;
@property (nonatomic, strong) UILabel *switchLabel;
- (void)configCellLeftTitle:(NSString *)leftTitle;
- (void)resetSeparatorLineShowAll:(BOOL)showAll;
@end
