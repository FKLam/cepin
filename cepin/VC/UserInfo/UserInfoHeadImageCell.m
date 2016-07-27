//
//  UserInfoHeadImageCell.m
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UserInfoHeadImageCell.h"

@implementation UserInfoHeadImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        self.contentView.backgroundColor = [[RTAPPUIHelper shareInstance] labelColorGreen];
//        [self.contentView addSubview:imageView];
        
        self.headImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImage.backgroundColor = [UIColor clearColor];
        self.headImage.layer.cornerRadius = 192 / 3.0 / 2.0;
        self.headImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headImage];
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@( 192 / 3.0 ));
            make.height.equalTo(@( 192 / 3.0 ));
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    NSLog(@"%f", self.viewHeight);
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
