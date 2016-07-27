//
//  CPTestEnsureArrowCell.m
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPTestEnsureArrowCell.h"
#import "CPCommon.h"
#import "NSString+Extension.h"
@interface CPTestEnsureArrowCell ()
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end
@implementation CPTestEnsureArrowCell
#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.leftTitleLabel];
        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.inputTextField];
        [self.contentView addSubview:self.separatorLine];
        [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.width.equalTo( @( self.leftTitleLabel.font.pointSize * 8 ) );
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.top.equalTo( self.mas_top ).offset( 30 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
        }];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.right.equalTo( self.arrowImageView.mas_left ).offset( 20 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.left.equalTo( self.leftTitleLabel.mas_right ).offset( 20 / CP_GLOBALSCALE);
        }];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return self;
}
+ (instancetype)ensureArrowCellWithTableView:(UITableView *)tableView
{
    static NSString *resueIdentifier = @"ensureArrowCell";
    CPTestEnsureArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:resueIdentifier];
    if ( !cell )
    {
        cell = [[CPTestEnsureArrowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueIdentifier];
    }
    return cell;
}
- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder
{
    [self.leftTitleLabel setText:str];
    [self.inputTextField setPlaceholder:placeholder];
}
- (void)resetSeparatorLineShowAll:(BOOL)showAll
{
    if ( showAll )
    {
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 0 );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    else
    {
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
}
#pragma mark - getter methods
- (UILabel *)leftTitleLabel
{
    if ( !_leftTitleLabel )
    {
        _leftTitleLabel = [[UILabel alloc] init];
        [_leftTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_leftTitleLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_leftTitleLabel setText:@"姓  名"];
    }
    return _leftTitleLabel;
}
- (CPArrowTextField *)inputTextField
{
    if ( !_inputTextField )
    {
        _inputTextField = [[CPArrowTextField alloc] init];
        [_inputTextField setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_inputTextField setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_inputTextField setTextAlignment:NSTextAlignmentRight];
        [_inputTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_inputTextField setEnabled:NO];
    }
    return _inputTextField;
}
- (UIView *)separatorLine
{
    if ( !_separatorLine )
    {
        _separatorLine = [[UIView alloc] init];
        [_separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3d6"]];
    }
    return _separatorLine;
}
- (UIImageView *)arrowImageView
{
    if ( !_arrowImageView )
    {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"ic_next"];
    }
    return _arrowImageView;
}
@end
