//
//  FullLanguageCell.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
#import "ResumeNameModel.h"
@interface FullLanguageCell : BaseFullCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *viewcell;
@property(nonatomic,strong)UILabel *des;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)createCellWithModel:(ResumeNameModel *)model languageViewHeight:(CGFloat)languageViewHeight;
@end
