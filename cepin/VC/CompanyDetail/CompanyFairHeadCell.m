//
//  CompanyFairHeadCell.m
//  cepin
//
//  Created by zhu on 15/1/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CompanyFairHeadCell.h"
#import "NSString+Extension.h"

@implementation CompanyFairHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [[RTAPPUIHelper shareInstance]shadeColor];
        self.backgroundColor = [UIColor clearColor];

        self.lableTile = [[UILabel alloc] initWithFrame:CGRectMake( 40 / 3.0, 0, kScreenWidth - 100, 120 / 3.0)];
        self.lableTile.text = @"该公司其他职位";
        self.lableTile.font = [[RTAPPUIHelper shareInstance] linkedWordsFont];
        self.lableTile.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.lableTile];
        
        self.lableMore = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 15 -10 - 60, 0, 60, 120 / 3.0)];
        self.lableMore.text = @"更多>>";
        self.lableMore.textAlignment = NSTextAlignmentRight;
        self.lableMore.backgroundColor = [UIColor clearColor];
        self.lableMore.font = [[RTAPPUIHelper shareInstance] linkedWordsFont];
        self.lableMore.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.lableMore];
    }
    return self;
}

- (void)layoutSubviews
{
    self.lableTile.viewWidth = [NSString caculateTextSize:self.lableTile].width;
    CGSize moreSize = [NSString caculateTextSize:self.lableMore];
    self.lableMore.viewWidth = moreSize.width;
    self.lableMore.viewX = kScreenWidth - 40 / 3.0 - moreSize.width;
}
@end
