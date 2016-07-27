//
//  CPResumeSelfDescribeView.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeSelfDescribeView.h"
#import "NSDate-Utilities.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPResumeEditReformer.h"
#import "CPCommon.h"
@interface CPResumeSelfDescribeView ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *mustWriteImageView;
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *guessLabel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *describeLabel;
@end
@implementation CPResumeSelfDescribeView
#pragma mark - lift cycle
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.blackBackgroundView];
        [self.blackBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}
- (void)configWithResume:(ResumeNameModel *)resumeModel title:(NSString *)title hideMustWriteFlag:(BOOL)hideFlag
{
    if ( title && 0 < [title length] )
        [self.guessLabel setText:title];
    [self.mustWriteImageView setHidden:hideFlag];
    [self configWithResume:resumeModel];
}
- (void)configWithResume:(ResumeNameModel *)resumeModel
{
    _resumeModel = resumeModel;
    if ( !_resumeModel.UserRemark || 0 == [_resumeModel.UserRemark length] )
    {
        [self.describeLabel setHidden:YES];
        [self.addMoreButton setHidden:NO];
        [self.editResumeButton setHidden:YES];
    }
    else
    {
        [self.addMoreButton setHidden:YES];
        [self.describeLabel setHidden:NO];
        [self.editResumeButton setHidden:NO];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_resumeModel.UserRemark];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]} range:NSMakeRange(0, [attStr length])];
        [self.describeLabel setAttributedText:attStr];
    }
}
#pragma mark - getter methods
- (UIView *)blackBackgroundView
{
    if ( !_blackBackgroundView )
    {
        _blackBackgroundView = [[UIView alloc] init];
        [_blackBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.04]];
        [_blackBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_blackBackgroundView.layer setMasksToBounds:YES];
        
        [_blackBackgroundView addSubview:self.whiteBackgroundView];
        [self.whiteBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _blackBackgroundView.mas_top );
            make.left.equalTo( _blackBackgroundView.mas_left );
            make.bottom.equalTo( _blackBackgroundView.mas_bottom ).offset( -6 / CP_GLOBALSCALE );
            make.right.equalTo( _blackBackgroundView.mas_right );
        }];
    }
    return _blackBackgroundView;
}
- (CPPositionDetailDescribeLabel *)describeLabel
{
    if ( !_describeLabel )
    {
        _describeLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_describeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_describeLabel setVerticalAlignment:VerticalAlignmentTop];
        [_describeLabel setNumberOfLines:0];
    }
    return _describeLabel;
}
- (UIView *)whiteBackgroundView
{
    if ( !_whiteBackgroundView )
    {
        _whiteBackgroundView = [[UIView alloc] init];
        [_whiteBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:1.0]];
        [_whiteBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_whiteBackgroundView.layer setMasksToBounds:YES];
        
        [_whiteBackgroundView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top );
            make.left.equalTo( _whiteBackgroundView.mas_left );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        
        [_whiteBackgroundView addSubview:self.describeLabel];
        [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _whiteBackgroundView.mas_bottom ).offset( -60 / CP_GLOBALSCALE );
        }];
        [_whiteBackgroundView addSubview:self.addMoreButton];
        [self.addMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topView.mas_bottom );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
    }
    return _whiteBackgroundView;
}
- (UIView *)topView
{
    if ( !_topView )
    {
        _topView = [[UIView alloc] init];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [_topView addSubview:self.titleBlueLineImageView];
        [_topView addSubview:self.guessLabel];
        [_topView addSubview:self.mustWriteImageView];
        [_topView addSubview:self.editResumeButton];
        
        [self.titleBlueLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _topView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [self.guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.guessLabel.font.pointSize ) );
        }];
        [self.mustWriteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.guessLabel.mas_right ).offset( 50 / CP_GLOBALSCALE );
            make.centerY.equalTo( self.guessLabel.mas_centerY );
            make.width.equalTo( @( 96 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [self.editResumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _topView.mas_right );
            make.top.equalTo( _topView.mas_top );
            make.width.equalTo( _topView.mas_height );
            make.height.equalTo( _topView.mas_height );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _topView.mas_bottom );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _topView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _topView;
}
- (UILabel *)guessLabel
{
    if ( !_guessLabel )
    {
        _guessLabel = [[UILabel alloc] init];
        [_guessLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_guessLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_guessLabel setText:@"自我描述"];
    }
    return _guessLabel;
}
- (UIImageView *)titleBlueLineImageView
{
    if( !_titleBlueLineImageView )
    {
        _titleBlueLineImageView = [[UIImageView alloc] init];
        _titleBlueLineImageView.image = [UIImage imageNamed:@"title_highlight"];
    }
    return _titleBlueLineImageView;
}
- (CPResumeInformationButton *)editResumeButton
{
    if ( !_editResumeButton )
    {
        _editResumeButton = [[CPResumeInformationButton alloc] init];
        [_editResumeButton setBackgroundColor:[UIColor clearColor]];
        [_editResumeButton setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
    }
    return _editResumeButton;
}
- (CPResumeMoreButton *)addMoreButton
{
    if ( !_addMoreButton )
    {
        _addMoreButton = [CPResumeMoreButton buttonWithType:UIButtonTypeCustom];
        [_addMoreButton setBackgroundColor:[UIColor clearColor]];
        [_addMoreButton setTitle:@"添加自我描述" forState:UIControlStateNormal];
        [_addMoreButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_addMoreButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_addMoreButton setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [_addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeMoreButton *sender) {
            
        }];
    }
    return _addMoreButton;
}
- (UIImageView *)mustWriteImageView
{
    if ( !_mustWriteImageView )
    {
        _mustWriteImageView = [[UIImageView alloc] init];
        _mustWriteImageView.image = [UIImage imageNamed:@"resume_ic_default"];
    }
    return _mustWriteImageView;
}
@end
