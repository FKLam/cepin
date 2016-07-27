//
//  JobSearchContentCell.m
//  cepin
//
//  Created by zhu on 15/1/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobSearchContentCell.h"
#import "NSString+Extension.h"

@implementation JobSearchContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lableTitle = [[UILabel alloc] init];
        self.lableTitle.font = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont];
        self.lableTitle.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.lableTitle];
      
        self.lineView = [[UIView alloc]initWithFrame:CGRectZero];
        self.lineView.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset( 40 / 3.0 );
            make.right.equalTo(self.contentView.mas_right).offset( 0 );
            make.bottom.equalTo(self.contentView.mas_bottom).offset( -1 );
            make.height.equalTo(@(0.5));
        }];
 
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize labelTitleSize = [NSString caculateTextSize:self.lableTitle];
    CGFloat labelTitleX = 40 / 3.0;
    CGFloat labelTitleY = 0.0;
    self.lableTitle.frame = CGRectMake(labelTitleX, labelTitleY, labelTitleSize.width, self.viewHeight);
}

@end
