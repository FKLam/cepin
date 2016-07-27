//
//  IndustrySecondCell.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "IndustrySecondCell.h"

@implementation IndustrySecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int hight = IS_IPHONE_5?21:25;
        self.contentView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 30)];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        [self.contentView addSubview:self.titleLabel];
        UIView *line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        
        self.chooseImage = [[UIImageView alloc]init];
        self.chooseImage.image = [UIImage imageNamed:@"ic_tick"];
        self.chooseImage.hidden = YES;
        [self.contentView addSubview:self.chooseImage];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(300));
            make.height.equalTo(self.mas_height);
        }];
        
        [self.chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.mas_top).offset(5);
            make.width.equalTo(@(hight));
            make.height.equalTo(@(hight));
        }];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(1));
        }];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.viewHeight = self.viewHeight;
}

@end
