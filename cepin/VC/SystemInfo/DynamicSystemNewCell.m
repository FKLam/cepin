//
//  DynamicSystemNewCell.m
//  cepin
//
//  Created by ceping on 14-12-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicSystemNewCell.h"
#import "CPCommon.h"

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
        self.roundView.borderColor = [UIColor whiteColor];
        self.roundView.fillColor = [UIColor whiteColor];
        [self.contentView addSubview:self.roundView];
        
        self.lableTitle = [[UILabel alloc] init];
        self.lableTitle.font = [[RTAPPUIHelper shareInstance]  searchResultTipsEndFont];
        self.lableTitle.textColor = [[RTAPPUIHelper shareInstance]  profileResumeNameColor];
        [self.roundView addSubview:self.lableTitle];
        
        
        self.lableTime = [[UILabel alloc] init];
        self.lableTime.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
        self.lableTime.textAlignment = NSTextAlignmentCenter;
        self.lableTime.textColor = [[RTAPPUIHelper shareInstance] profileResumeMessageColor];
        [self.roundView addSubview:self.lableTime];
  
        self.subLabel = [[UILabel alloc] init];
        self.subLabel.font = [[RTAPPUIHelper shareInstance] profileResumeMessageFont];
        self.subLabel.textColor = [[RTAPPUIHelper shareInstance] profileResumeNameColor];
        self.subLabel.userInteractionEnabled = NO;
        self.subLabel.numberOfLines = 1;
        [self.subLabel setOpaque:NO];
        [self.roundView addSubview:self.subLabel];
        
        UIView *line = [[UIView alloc] init];
//        line.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        line.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 1.0);
        [self.roundView addSubview:line];
        _lineView = line;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.roundView.mas_right);
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.height.equalTo(@(1));
            make.left.equalTo(self.roundView.mas_left).offset( 40 / 3.0 );
        }];
    }
    return self;
}
- (void)layoutSubviews
{
//    int width = [[self class] companyWithTime:self.lableTime.text];
//    self.roundView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
//    self.lableTitle.frame = CGRectMake(20, 10, self.roundView.viewWidth - width - 30, IS_IPHONE_5?12:14.4);
//    self.lableTime.frame = CGRectMake(kScreenWidth - width - 10, self.lableTitle.viewY, width, IS_IPHONE_5?12:14.4);
//    self.subLabel.frame = CGRectMake(20, self.lableTitle.viewY + self.lableTitle.viewHeight + 10, kScreenWidth - 30, IS_IPHONE_5?12:13);
    
    [super layoutSubviews];
    
    CGFloat horizontal_marge = 40 / 3.0;
    
    CGSize titleSize = [self caculateUIControlSize:self.lableTitle];
    CGFloat titleX = horizontal_marge;
    CGFloat titleY = horizontal_marge;
    
    CGSize timeSize = [self caculateUIControlSize:self.lableTime];
    CGFloat timeX = self.viewWidth - timeSize.width - horizontal_marge;
    
    CGFloat maxMarge = timeX - horizontal_marge * 2;
    
    if ( titleSize.width > maxMarge )
        titleSize.width = maxMarge;
    
    self.lableTitle.frame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    
    self.lableTime.frame = CGRectMake(timeX, titleY + ( titleSize.height - timeSize.height ) / 2.0, timeSize.width, timeSize.height);
    
    CGSize statueSize = [self caculateUIControlSize:self.subLabel];
    CGFloat statueX = horizontal_marge;
    CGFloat statueY = self.viewHeight - horizontal_marge - statueSize.height;
    CGFloat maxStatueMarge = self.viewWidth - horizontal_marge * 2;
    if ( statueSize.width > maxStatueMarge )
        statueSize.width = maxStatueMarge;
    self.subLabel.frame = CGRectMake(statueX, statueY, statueSize.width, statueSize.height);
    
}

+(int)companyWithTime:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance] titleFont]);
    return size.width;
}

/**
 *  返回UILabel控件文本的size
 *
 *  @param   control  控件
 *  @return  CGSize   控件文本的size
 */
- (CGSize)caculateUIControlSize:(UIView *)control
{
    if ( ![control isKindOfClass:[UILabel class] ] )
        return CGSizeZero;
    
    UILabel *label = (UILabel *)control;
    
    CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : label.font } context:nil].size;
    
    return labelSize;
}
@end
