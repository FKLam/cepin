//
//  AboutCell.m
//  cepin
//
//  Created by dujincai on 15/5/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AboutCell.h"

@implementation AboutCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //ic_next
        int hight = IS_IPHONE_5?11:13;
//        int hi = IS_IPHONE_5?7;10;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance]titleFont];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(hight));
            make.width.equalTo(@(200));
        }];
        
        self.arrowImage = [[UIImageView alloc]init];
        self.arrowImage.image = [UIImage imageNamed:@"ic_next"];
        [self addSubview:self.arrowImage];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(imagehight));
            make.width.equalTo(@(imagehight));
        }];
        
        self.subLabel = [[UILabel alloc]init];
        self.subLabel.textAlignment = NSTextAlignmentRight;
        self.subLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.subLabel.font = [[RTAPPUIHelper shareInstance]subTitleFont];
        [self addSubview:self.subLabel];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImage.mas_left);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(hight));
            make.width.equalTo(@(200));
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self addSubview:line];
        _line = line;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.right.equalTo(self.mas_right).offset( 0 );
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.height.equalTo(@( 1 ));
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

@end
