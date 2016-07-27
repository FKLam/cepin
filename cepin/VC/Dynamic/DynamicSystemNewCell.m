//
//  DynamicSystemNewCell.m
//  cepin
//
//  Created by ceping on 14-12-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicSystemNewCell.h"

@implementation DynamicSystemNewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.roundView = [[TKRoundedView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        self.roundView.backgroundColor = [UIColor whiteColor];
//        self.roundView.layer.cornerRadius = 6.f;
//        self.roundView.layer.masksToBounds = YES;
        self.roundView.borderColor = [UIColor whiteColor];
        self.roundView.fillColor = [UIColor whiteColor];
        [self.contentView addSubview:self.roundView];
        
        self.lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.roundView.viewWidth, IS_IPHONE_5?12:14.4)];
        self.lableTitle.font = [[RTAPPUIHelper shareInstance] mainTitleFont];
        self.lableTitle.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.roundView addSubview:self.lableTitle];
        
        
        self.lableTime = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 100, 32)];
        self.lableTime.font = [[RTAPPUIHelper shareInstance]subTitleFont];
        self.lableTime.textAlignment = NSTextAlignmentCenter;
        self.lableTime.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        [self.roundView addSubview:self.lableTime];
        int hight = IS_IPHONE_5?9:10;
        int width = IS_IPHONE_5?95:90;
        [self.lableTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.roundView.mas_right).offset(-10);
            make.top.equalTo(self.roundView.mas_top).offset(10);
            make.height.equalTo(@(hight));
            make.width.equalTo(@(width));
        }];
        
        
        self.subLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.lableTitle.viewY + self.lableTitle.viewHeight + 10, self.roundView.viewWidth - 30, IS_IPHONE_5?11:12.6)];
        self.subLabel.font = [[RTAPPUIHelper shareInstance]titleFont];
        self.subLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.subLabel.userInteractionEnabled = NO;
        self.subLabel.numberOfLines = 1;
        [self.subLabel setOpaque:NO];
        [self.roundView addSubview:self.subLabel];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.roundView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.roundView.mas_right);
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.height.equalTo(@(1));
            make.left.equalTo(self.roundView.mas_left).offset(20);
        }];
    }
    return self;
}

@end
