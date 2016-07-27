//
//  JobSearchTitleCell.m
//  cepin
//
//  Created by zhu on 15/1/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobSearchTitleCell.h"

@implementation JobSearchTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backWhiteView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.backWhiteView];
        [self.backWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top);
            make.height.equalTo(self.contentView.mas_height);
        }];
        self.backWhiteView.backgroundColor = [UIColor clearColor];
        
        
        self.lableTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.backWhiteView addSubview:self.lableTitle];
        [self.lableTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backWhiteView.mas_left).offset( 40 / 3.0 );
            make.top.equalTo(self.backWhiteView.mas_top).offset(0);
            make.right.equalTo(self.backWhiteView.mas_right).offset(0);
            make.bottom.equalTo(self.backWhiteView.mas_bottom).offset(0);
        }];
        
        self.lableTitle.font = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont];
        self.lableTitle.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        
        
//        self.lineView = [[UIView alloc]initWithFrame:CGRectZero];
//        [self.backWhiteView addSubview:self.lineView];
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset( 40.0 / 3.0 );
//            make.right.equalTo(self.contentView.mas_right).offset( 0);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset( -1 );
//            make.height.equalTo(@( 0.5 ));
//        }];
//        
//        self.lineView.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
