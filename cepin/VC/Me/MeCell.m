//
//  MeCell.m
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "MeCell.h"
#import "CPCommon.h"
#import "NSString+Extension.h"
@interface MeCell ()
@property (nonatomic, copy) NSString *leftImageNormalName;
@property (nonatomic, copy) NSString *leftImageHightLightName;
@end
@implementation MeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftImage = [[UIImageView alloc] init];
        [self.leftImage setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.leftImage];
        self.title = [[UILabel alloc] init];
        [self.title setBackgroundColor:[UIColor clearColor]];
        [self.title setFont:[UIFont systemFontOfSize:42.0 / CP_GLOBALSCALE]];
        self.title.textColor = [UIColor colorWithHexString:@"404040" alpha:1.0];
        [self.contentView addSubview:self.title];
        self.rightArrow = [[UIImageView alloc]init];
        [self.rightArrow setBackgroundColor:[UIColor clearColor]];
        self.rightArrow.image = [UIImage imageNamed:@"ic_next"];
        CGSize arrowSize = self.rightArrow.image.size;
        [self.contentView addSubview:self.rightArrow];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@( arrowSize.width / CP_GLOBALSCALE));
            make.width.equalTo(@( arrowSize.width / CP_GLOBALSCALE));
        }];
        self.reminderView = [[UILabel alloc] init];
        self.reminderView.textColor = [UIColor colorWithHexString:@"ffffff"];
        self.reminderView.font = [UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE];
        [self.reminderView setBackgroundColor:[UIColor colorWithHexString:@"ff5252"]];
        [self.reminderView.layer setCornerRadius:50.0 / 2.0 / CP_GLOBALSCALE];
        [self.reminderView.layer setMasksToBounds:YES];
        [self.reminderView setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.reminderView];
        self.reminderView.hidden = YES;
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:CPColor(0xed, 0xe3, 0xe6, 1.0)];
        [self.contentView addSubview:lineView];
        _lineView = lineView;
        
    }
    return self;
}
- (void)setLeftNormalImage:(NSString *)normal hightLightImage:(NSString *)hightLight
{
    _leftImageNormalName = normal;
    _leftImageHightLightName = hightLight;
    
    self.leftImage.image = [UIImage imageNamed:_leftImageNormalName];
}
- (void)layoutSubviews
{
    CGSize imageSize = self.leftImage.image.size;
    self.leftImage.frame = CGRectMake( 40 / CP_GLOBALSCALE - imageSize.width / CP_GLOBALSCALE / 6.0, fabs( self.viewHeight - imageSize.height / CP_GLOBALSCALE ) / 2.0, imageSize.width / CP_GLOBALSCALE, imageSize.height / CP_GLOBALSCALE);
    self.title.frame = CGRectMake(CGRectGetMaxX(self.leftImage.frame) + 40 / CP_GLOBALSCALE - imageSize.width / CP_GLOBALSCALE / 6.0, 0, self.viewWidth - CGRectGetMaxX(self.leftImage.frame), self.viewHeight);
    if ( !self.separatorLineShowLong )
        self.lineView.frame = CGRectMake(40 / CP_GLOBALSCALE, self.viewHeight - 2 / CP_GLOBALSCALE, self.viewWidth - 40 / CP_GLOBALSCALE, 2 / CP_GLOBALSCALE);
    else
        self.lineView.frame = CGRectMake(0, self.viewHeight - 2 / CP_GLOBALSCALE, self.viewWidth, 2 / CP_GLOBALSCALE);
    
    if ( [self.reminderView.text length] > 0 )
    {
        CGFloat height = 50 / CP_GLOBALSCALE;
        CGFloat width = 70 / CP_GLOBALSCALE;
        if ( [self.reminderView.text length] > 2 )
        {
            width = width + 50 / CP_GLOBALSCALE / 2.0;
            self.reminderView.text = @"99+";
        }
        self.reminderView.frame = CGRectMake(self.rightArrow.viewX - width - 2.0, (self.viewHeight - height * CP_DPI_SCALE ) / 2.0, width, 50 / CP_GLOBALSCALE);
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ( self.isHighlighted || self.isSelected )
    {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f0eef5" alpha:1.0];
        self.title.textColor = [UIColor colorWithHexString:@"288add" alpha:1.0];
        
        self.leftImage.image = [UIImage imageNamed:self.leftImageHightLightName];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.title.textColor = [UIColor colorWithHexString:@"404040" alpha:1.0];
        self.leftImage.image = [UIImage imageNamed:self.leftImageNormalName];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setNeedsDisplay];
}
@end
