//
//  CPResumedGuideEditCell.m
//  cepin
//
//  Created by ceping on 16/1/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumedGuideEditCell.h"
#import "CPTestEnsureEditCell.h"

@interface CPResumedGuideEditCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *tipsView;

@end

@implementation CPResumedGuideEditCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self.contentView addSubview:self.leftTitleLabel];
        [self.contentView addSubview:self.inputTextField];
        
        [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / 3.0 );
            make.height.equalTo( @( 144 / 3.0 ) );
        }];
        
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.right.equalTo( self.mas_right ).offset( -40 / 3.0 );
            make.height.equalTo( self.leftTitleLabel );
            make.left.equalTo( self.leftTitleLabel.mas_right ).offset( 40 / 3.0);
        }];
        
        [self.inputTextField setDelegate:self];
    }
    return self;
}

+ (instancetype)ensureEditCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"resumedGuideEditCell";
    CPResumedGuideEditCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPResumedGuideEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder
{
    [self.leftTitleLabel setText:str];
    [self.inputTextField setPlaceholder:placeholder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( [self.resumedGuideEditCellDelegate respondsToSelector:@selector(guideEditCell:beginEditEmail:)])
    {
        [self.resumedGuideEditCellDelegate guideEditCell:self beginEditEmail:self.inputTextField];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( [self.resumedGuideEditCellDelegate respondsToSelector:@selector(guideEditCell:endEdit:)])
    {
        [self.resumedGuideEditCellDelegate guideEditCell:self endEdit:self.inputTextField];
    }
}
#pragma mark - getter methods
- (UIView *)tipsView
{
    if ( !_tipsView )
    {
        _tipsView = [[UIView alloc] init];
        [_tipsView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        
        UILabel *tipsLabel = [[UILabel alloc] init];
        [tipsLabel setNumberOfLines:0];
        NSString *tipsStr = @"绑定邮箱,可获得找回密码,职位推荐,投递动态,HR通知等服务,请输入常用邮箱并完成注册后登录邮箱验证。";
        NSMutableParagraphStyle *paragrapHStyle = [[NSMutableParagraphStyle alloc] init];
        [paragrapHStyle setLineSpacing:18 / 3.0];
        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithString:tipsStr attributes:@{
                                                                                                                    NSFontAttributeName : [UIFont systemFontOfSize:36 / 3.0],
                                                                                                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"],
                                                                                                                    NSParagraphStyleAttributeName : paragrapHStyle
                                                                                                                    }];
        [tipsLabel setAttributedText:attStrM];
        
        [_tipsView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _tipsView.mas_top ).offset( 60 / 3.0 );
            make.left.equalTo( _tipsView.mas_left ).offset( 40 / 3.0 );
            make.right.equalTo( _tipsView.mas_right ).offset( -20 / 3.0 );
            make.height.equalTo( @( ( 42 * 2 + 18 * 2 ) / 3.0 ) );
        }];
        
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3d6"]];
        [_tipsView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _tipsView );
            make.height.equalTo( @( 2 / 3.0 ) );
            make.right.equalTo( _tipsView.mas_right );
            make.bottom.equalTo( _tipsView.mas_bottom );
        }];
        [_tipsView setHidden:YES];
    }
    return _tipsView;
}
- (UILabel *)leftTitleLabel
{
    if ( !_leftTitleLabel )
    {
        _leftTitleLabel = [[UILabel alloc] init];
        [_leftTitleLabel setFont:[UIFont systemFontOfSize:42 / 3.0]];
        [_leftTitleLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_leftTitleLabel setText:@"姓  名"];
    }
    return _leftTitleLabel;
}
- (CPTestEnsureTextFiled *)inputTextField
{
    if ( !_inputTextField )
    {
        _inputTextField = [[CPTestEnsureTextFiled alloc] init];
        [_inputTextField setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_inputTextField setFont:[UIFont systemFontOfSize:42 / 3.0]];
        [_inputTextField setTextAlignment:NSTextAlignmentRight];
        [_inputTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        _inputTextField.placeholder = @"请输入姓名";
    }
    return _inputTextField;
}

@end
