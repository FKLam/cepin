//
//  ExperienceCell.h
//  cepin
//
//  Created by dujincai on 15-4-22.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
@interface ExperienceCell : BaseFullCell
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *position;

@property (nonatomic, strong) UIView *separatorView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
