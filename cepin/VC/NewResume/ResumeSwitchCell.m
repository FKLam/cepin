//
//  ResumeSwitchCell.m
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeSwitchCell.h"
#import "CPCommon.h"
@interface ResumeSwitchCell ()
@end
@implementation ResumeSwitchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.line = [[UIView alloc]init];
        self.line.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@( 2 / CP_GLOBALSCALE ));
            make.left.equalTo(self.mas_left).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
        int width = 147 / CP_GLOBALSCALE;
        self.Switchimage  = [[UIButton alloc]init];
        [self.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        [self addSubview:self.Switchimage];
        [self.Switchimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset( - ( 45 / CP_GLOBALSCALE ) );
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(width));
            make.top.equalTo( self.mas_top ).offset( 27 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom ).offset( -( 27 / CP_GLOBALSCALE ) );
        }];
        UILabel *switchLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
        switchLabel.text = @"允许被推送到匹配的职位";
        switchLabel.textColor = [UIColor colorWithHexString:@"707070"];
        switchLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        [self addSubview:switchLabel];
        self.switchLabel = switchLabel;
        [switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.left.equalTo(self.mas_left).offset( 40 / CP_GLOBALSCALE );
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}
- (void)configCellLeftTitle:(NSString *)leftTitle
{
    [self.switchLabel setText:leftTitle];
}
- (void)resetSeparatorLineShowAll:(BOOL)showAll
{
    if ( showAll )
    {
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 0 );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    else
    {
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
}
@end
