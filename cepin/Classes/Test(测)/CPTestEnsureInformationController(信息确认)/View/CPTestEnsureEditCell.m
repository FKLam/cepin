//
//  CPTestEnsureEditCell.m
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPTestEnsureEditCell.h"
#import "CPCommon.h"
@interface CPTestEnsureEditCell ()

@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation CPTestEnsureEditCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.leftTitleLabel];
        [self.contentView addSubview:self.inputTextField];
        [self.contentView addSubview:self.separatorLine];
        [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.width.equalTo( @( self.leftTitleLabel.font.pointSize * 8 ) );
        }];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.right.equalTo( self.mas_right ).offset( -20 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.left.equalTo( self.leftTitleLabel.mas_right ).offset( 40 / CP_GLOBALSCALE);
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
+ (instancetype)ensureEditCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"ensureEditCell";
    CPTestEnsureEditCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPTestEnsureEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder
{
    [self.leftTitleLabel setText:str];
    [self.inputTextField setPlaceholder:placeholder];
}
- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder editButton:(UIButton *)editButton
{
    [self configCellLeftString:str placeholder:placeholder];
    self.editButton = editButton;
    [_editButton setFrame:self.bounds];
    [_editButton setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_editButton];
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
        [_leftTitleLabel setText:@""];
    }
    return _leftTitleLabel;
}
- (CPTestEnsureTextFiled *)inputTextField
{
    if ( !_inputTextField )
    {
        _inputTextField = [[CPTestEnsureTextFiled alloc] init];
        [_inputTextField setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_inputTextField setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_inputTextField setTextAlignment:NSTextAlignmentRight];
        [_inputTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_inputTextField setTag:CPTestEnsureEditMaxTag];
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

@end
