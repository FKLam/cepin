//
//  ResumeIsAbroadCell.m
//  cepin
//
//  Created by dujincai on 15/7/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeIsAbroadCell.h"
#import "NSString+Extension.h"

@implementation ResumeIsAbroadCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int hight = 24.0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.text = @"海外经历";
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformatonFont];
        self.line = [[UIView alloc]init];
        [self addSubview:self.line];
        
        self.buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];

        [self.buttonImage setBackgroundImage:[UIImage imageNamed:@"ic_radio_null"] forState:UIControlStateNormal];
        
        [self addSubview:self.buttonImage];
//        int width = IS_IPHONE_5?50:60;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([NSString caculateTextSize:self.titleLabel].width));
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.height.equalTo(self.mas_height);
        }];
        
        [self.buttonImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset( -40 / 3.0 );
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(hight * 1.8 ));
            make.height.equalTo(@(hight));
        }];
        self.line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.left.equalTo(self.mas_left).offset(10);
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
    
    self.titleLabel.viewWidth = [NSString caculateTextSize:self.titleLabel].width;
}

@end
