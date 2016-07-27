//
//  OtherAddressCell.m
//  cepin
//
//  Created by dujincai on 15/7/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "OtherAddressCell.h"

@implementation OtherAddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 150, IS_IPHONE_5?9:11)];
        self.otherLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.otherLabel.font = [[RTAPPUIHelper shareInstance]subTitleFont];
        [self addSubview:self.otherLabel];
        
        [self.otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(100));
            make.height.equalTo(self.mas_height);
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
