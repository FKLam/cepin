//
//  CPTestEnsureSexCell.m
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPTestEnsureSexCell.h"
#import "CPTestSexButton.h"
#import "CPCommon.h"
@interface CPTestEnsureSexCell ()
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) CPTestSexButton *maleButton;
@property (nonatomic, strong) CPTestSexButton *femaleButton;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) CPTestSexButton *selectedButton;
@end
@implementation CPTestEnsureSexCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.leftTitleLabel];
        [self.contentView addSubview:self.separatorLine];
        [self.contentView addSubview:self.maleButton];
        [self.contentView addSubview:self.femaleButton];
        
        [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
        }];
        
        [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.right.equalTo( self.mas_right );
            make.bottom.equalTo( self.mas_bottom );
            make.width.equalTo( @( kScreenWidth / 3.0 ) );
        }];
        [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.right.equalTo( self.femaleButton.mas_left );
            make.width.equalTo( self.femaleButton );
            make.height.equalTo( self.femaleButton );
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
+ (instancetype)ensureSexCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"ensureSexCell";
    CPTestEnsureSexCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPTestEnsureSexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configWithSex:(NSNumber *)sexNumber
{
    // Int	性别（0 未知1：男 ，2：女）Gender
    NSInteger genderInt = [sexNumber integerValue];
    if ( 0 == genderInt || 1 == genderInt )
    {
        [self.maleButton setSelected:YES];
        [self.femaleButton setSelected:NO];
        self.selectedButton = self.maleButton;
    }
    else if ( 2 == genderInt )
    {
        [self.maleButton setSelected:NO];
        [self.femaleButton setSelected:YES];
        self.selectedButton = self.femaleButton;
    }
}
#pragma mark - events respond
- (void)changeSexWithButton:(CPTestSexButton *)sender
{
    if ( self.selectedButton.tag == sender.tag )
        return;
    self.selectedButton = sender;
    if ( [self.ensureSexCellDelegate respondsToSelector:@selector(ensureSexCell:changeSexWithSexNumber:)] )
    {
        [self.ensureSexCellDelegate ensureSexCell:self changeSexWithSexNumber:self.selectedButton.tag];
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
        [_leftTitleLabel setText:@"性  别"];
    }
    return _leftTitleLabel;
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
- (CPTestSexButton *)maleButton
{
    if ( !_maleButton )
    {
        _maleButton = [CPTestSexButton buttonWithType:UIButtonTypeCustom];
        [_maleButton setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        [_maleButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_maleButton setImage:[UIImage imageNamed:@"ic_male"] forState:UIControlStateNormal];
        [_maleButton setImage:[UIImage imageNamed:@"ic_male_selected"] forState:UIControlStateSelected];
        [_maleButton setTitle:@"男" forState:UIControlStateNormal];
        [_maleButton setTag:CPSexButtonMale];
        [_maleButton addTarget:self action:@selector(changeSexWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maleButton;
}
- (CPTestSexButton *)femaleButton
{
    if ( !_femaleButton )
    {
        _femaleButton = [CPTestSexButton buttonWithType:UIButtonTypeCustom];
        [_femaleButton setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        [_femaleButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_femaleButton setImage:[UIImage imageNamed:@"ic_female"] forState:UIControlStateNormal];
        [_femaleButton setImage:[UIImage imageNamed:@"ic_female_selected"] forState:UIControlStateSelected];
        [_femaleButton setTitle:@"女" forState:UIControlStateNormal];
        [_femaleButton setTag:CPSexButtonFemale];
        [_femaleButton addTarget:self action:@selector(changeSexWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _femaleButton;
}
@end
