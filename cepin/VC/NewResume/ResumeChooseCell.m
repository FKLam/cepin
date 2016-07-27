//
//  ResumeChooseCell.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface ResumeChooseCell ()
@property (nonatomic, strong) UIView *separatorLine;
@end
@implementation ResumeChooseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int hight = 70 / CP_GLOBALSCALE;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 85 / CP_GLOBALSCALE, 5, self.viewWidth - 40 / CP_GLOBALSCALE * 2 - 21, self.viewHeight)];
        self.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"404040"];
        [self.contentView addSubview:self.titleLabel];
        
        self.chooseImage = [[UIImageView alloc]init];
        self.chooseImage.image = [UIImage imageNamed:@"ic_tick"];
        [self.contentView addSubview:self.chooseImage];
        [self.chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo( @( hight ) );
            make.height.equalTo( @( hight ));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40.0 / CP_GLOBALSCALE );
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset( -(40 / CP_GLOBALSCALE + 21.0) );
            make.height.equalTo(self.mas_height);
        }];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.contentView addSubview:line];
        self.separatorLine = line;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo( self.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        self.chooseImage.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setIsSelect:(BOOL)isSelect
{
    if (isSelect)
    {
        self.chooseImage.image = [UIImage imageNamed:@"ic_tick"];
        self.chooseImage.hidden = NO;
    }
    else
    {
        self.chooseImage.image = [UIImage imageNamed:@""];
        self.chooseImage.hidden =YES;
    }
}
- (void)showSeparatorLine:(BOOL)isShowAll
{
    CGFloat offset = 0;
    if ( !isShowAll )
        offset = 40 / CP_GLOBALSCALE;
    [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( offset );
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo( self.mas_bottom );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
    }];
}
@end
