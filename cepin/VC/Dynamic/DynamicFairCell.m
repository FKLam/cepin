//
//  DynamicFairCell.m
//  cepin
//
//  Created by ceping on 14-12-29.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicFairCell.h"

@implementation DynamicFairCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.viewBackgound = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.viewBackgound];
        [self.viewBackgound mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        self.viewBackgound.backgroundColor = [UIColor whiteColor];
        
        self.lableTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.viewBackgound addSubview:self.lableTitle];
         [self.lableTitle mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.viewBackgound.mas_left).offset(10);
             make.right.equalTo(self.viewBackgound.mas_right).offset(-10);
             make.top.equalTo(self.viewBackgound.mas_top).offset(10);
             make.height.equalTo(@(20));
         }];
        
        self.lableTitle.textColor = UIColorFromRGB(0x444444);
        self.lableTitle.backgroundColor = [UIColor clearColor];
        self.lableTitle.font = [UIFont boldSystemFontOfSize:16];
        
        self.lableTime = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.viewBackgound addSubview:self.lableTime];
        [self.lableTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lableTitle.mas_left);
            make.right.equalTo(self.lableTitle.mas_right);
            make.top.equalTo(self.lableTitle.mas_bottom).offset(10);
            make.height.equalTo(@(20));
        }];
        
        self.lableTime.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.lableTime.backgroundColor = [UIColor clearColor];
        self.lableTime.font = [UIFont systemFontOfSize:12];
        
        self.lableAddress = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.viewBackgound addSubview:self.lableAddress];
        [self.lableAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lableTime.mas_left);
            make.right.equalTo(self.lableTime.mas_right);
            make.top.equalTo(self.lableTime.mas_bottom).offset(10);
            make.height.equalTo(@(20));
        }];
        
        self.lableAddress.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.lableAddress.font = [UIFont systemFontOfSize:12];
        self.lableAddress.backgroundColor = [UIColor clearColor];
        
        
        self.imageArrow = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.viewBackgound addSubview:self.imageArrow];
        [self.imageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.viewBackgound.mas_right).offset(-20);
            make.centerY.equalTo(self.lableTime.mas_centerY);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
        
        self.imageArrow.image = UIIMAGE(@"indicate_right_grey");
    }
    return self;
}

@end
