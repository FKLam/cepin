//
//  RecommendTitleCell.m
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "RecommendTitleCell.h"

@implementation RecommendTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, IS_IPHONE_5?5:10, self.viewWidth - 50,IS_IPHONE_5?15:20)];
        self.titlelabel.font = [[RTAPPUIHelper shareInstance] recommendBlockTitleFont];
        self.titlelabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
//        self.titlelabel.text = @"最新发布";
#pragma mark - 标题修改为：发掘更多机会
        self.titlelabel.text = @"发掘更多机会";
        [self addSubview:self.titlelabel];
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
