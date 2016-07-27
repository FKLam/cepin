//
//  ResumeMenuCell.m
//  cepin
//
//  Created by ceping on 15-3-11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeMenuCell.h"

@implementation ResumeMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLable = [[UILabel alloc]init];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        self.titleLable.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.titleLable.alpha = 0.87;
        [self addSubview:self.titleLable];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(20));
        }];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
