//
//  CPProfileMyResumesCell.m
//  cepin
//
//  Created by ceping on 16/1/6.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPProfileMyResumesCell.h"
#import "CPCommon.h"
@interface CPProfileMyResumesCell()

@property (nonatomic, strong) AllResumeDataModel *resumeModel;
@property (nonatomic, strong) UIView *fixdBackgroundView;
@property (nonatomic, strong) UIView *fixdBackBackgroundView;
@property (nonatomic, strong) UILabel *resumeNameLabel;
@property (nonatomic, strong) UIImageView *defaultResumeImageView;
@property (nonatomic, strong) UIImageView *schoolImageView;
@property (nonatomic, strong) UILabel *resumeStatusLabel;
@property (nonatomic, strong) UIView *HorizontalSeparatorLine;
@property (nonatomic, strong) UIView *verticalSeparatorLine;
@property (nonatomic, strong) UIView *verticalSeparatorLine1;
@property (nonatomic, strong) UIView *verticalSeparatorLine2;
@end

@implementation CPProfileMyResumesCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        self.backgroundColor = [UIColor clearColor];
        
        // 阴影背景
        [self.contentView addSubview:self.fixdBackBackgroundView];
        [self.fixdBackBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        
        // 白色背景
        [self.contentView addSubview:self.fixdBackgroundView];
        [self.fixdBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom ).offset( -6 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        
        // 默认简历图标
        [self.fixdBackgroundView addSubview:self.defaultResumeImageView];
        [self.defaultResumeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.fixdBackgroundView.mas_top );
            make.right.equalTo( self.fixdBackgroundView.mas_right );
            make.width.equalTo( @( self.defaultResumeImageView.image.size.width / CP_GLOBALSCALE ) );
            make.height.equalTo( @( self.defaultResumeImageView.image.size.height / CP_GLOBALSCALE ) );
        }];
        
        // 简历名称
        [self.fixdBackgroundView addSubview:self.resumeNameLabel];
        [self.resumeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.fixdBackgroundView.mas_top).offset( 72.0 / CP_GLOBALSCALE );
            make.left.equalTo( self.fixdBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        }];
        
        // 校招简历图标
        [self.fixdBackgroundView addSubview:self.schoolImageView];
        [self.schoolImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.resumeNameLabel.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.centerY.equalTo( self.resumeNameLabel.mas_centerY);
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        
        // 水平分割线
        [self.fixdBackgroundView addSubview:self.HorizontalSeparatorLine];
        [self.HorizontalSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.fixdBackgroundView.mas_left );
            make.bottom.equalTo( self.fixdBackgroundView.mas_bottom ).offset( -120.0 / CP_GLOBALSCALE );
            make.right.equalTo( self.fixdBackgroundView.mas_right );
            make.height.equalTo( @( 2.0 / CP_GLOBALSCALE ) );
        }];
        
        // 预览按钮
        [self.fixdBackgroundView addSubview:self.resumeReviewButton];
        [self.resumeReviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self.fixdBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.HorizontalSeparatorLine.mas_top ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 90 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( 210 / CP_GLOBALSCALE ) );
        }];
        
        // 简历浏览数标签
        [self.fixdBackgroundView addSubview:self.resumeReviewLabel];
        [self.resumeReviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self.resumeReviewButton.mas_left ).offset( -60 / CP_GLOBALSCALE );
            make.width.equalTo( @( 210 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 90 / CP_GLOBALSCALE ) );
            make.top.equalTo( self.resumeReviewButton.mas_top );
        }];
        
        // 简历是否可投状态
        [self.fixdBackgroundView addSubview:self.resumeStatusLabel];
        [self.resumeStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.resumeReviewButton.mas_centerY);
            make.left.equalTo( self.resumeNameLabel.mas_left );
            make.height.equalTo( @( self.resumeStatusLabel.font.pointSize ) );
        }];
        
        // 设置默认简历的按钮
        [self.fixdBackgroundView addSubview:self.resumeSetDefualtButton];
        [self.fixdBackgroundView addSubview:self.verticalSeparatorLine];
        
        // 复制简历的按钮
        [self.fixdBackgroundView addSubview:self.resumeCopyButton];
        [self.fixdBackgroundView addSubview:self.verticalSeparatorLine1];
        
        // 删除简历的按钮
        [self.fixdBackgroundView addSubview:self.resumeDeleteButton];
        [self.fixdBackgroundView addSubview:self.verticalSeparatorLine2];
        
        // 编辑简历的按钮
        [self.fixdBackgroundView addSubview:self.resumeEditButton];
        
        [self.resumeSetDefualtButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.HorizontalSeparatorLine.mas_bottom );
            make.left.equalTo( self.fixdBackgroundView.mas_left );
            make.bottom.equalTo( self.fixdBackgroundView.mas_bottom );
            make.right.equalTo( self.verticalSeparatorLine.mas_left );
            
        }];
        
        [self.verticalSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo( @( 46 / CP_GLOBALSCALE ) );
            make.top.equalTo( self.HorizontalSeparatorLine.mas_bottom ).offset( (120 - 46) / CP_GLOBALSCALE / 2.0 );
            make.left.equalTo( self.resumeSetDefualtButton.mas_right );
            make.width.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        
        [self.resumeCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.HorizontalSeparatorLine.mas_bottom );
            make.left.equalTo( self.verticalSeparatorLine.mas_right );
            make.bottom.equalTo( self.fixdBackgroundView.mas_bottom );
            make.right.equalTo( self.verticalSeparatorLine1.mas_left );
            make.width.equalTo( self.resumeSetDefualtButton.mas_width );
        }];
        
        [self.verticalSeparatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo( self.verticalSeparatorLine.mas_height );
            make.top.equalTo( self.verticalSeparatorLine.mas_top );
            make.left.equalTo( self.resumeCopyButton.mas_right );
            make.width.equalTo( self.verticalSeparatorLine.mas_width );
        }];
        
        [self.resumeDeleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.HorizontalSeparatorLine.mas_bottom );
            make.left.equalTo( self.verticalSeparatorLine1.mas_right );
            make.bottom.equalTo( self.fixdBackgroundView.mas_bottom );
            make.right.equalTo( self.verticalSeparatorLine2.mas_left );
            make.width.equalTo( self.resumeSetDefualtButton.mas_width );
        }];
        
        [self.verticalSeparatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo( self.verticalSeparatorLine.mas_height );
            make.top.equalTo( self.verticalSeparatorLine.mas_top );
            make.left.equalTo( self.resumeDeleteButton.mas_right );
            make.width.equalTo( self.verticalSeparatorLine.mas_width );
        }];
        
        [self.resumeEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.HorizontalSeparatorLine.mas_bottom );
            make.left.equalTo( self.verticalSeparatorLine2.mas_right );
            make.bottom.equalTo( self.fixdBackgroundView.mas_bottom );
            make.right.equalTo( self.fixdBackgroundView.mas_right );
            make.width.equalTo( self.resumeSetDefualtButton.mas_width );
        }];
        
    }
    return self;
}

+ (instancetype)resumeCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"resumeCell";
    CPProfileMyResumesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[CPProfileMyResumesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)resetStatues
{
    [self.resumeSetDefualtButton setBackgroundColor:[UIColor clearColor]];
    [self.resumeCopyButton setBackgroundColor:[UIColor clearColor]];
    [self.resumeDeleteButton setBackgroundColor:[UIColor clearColor]];
    [self.resumeEditButton setBackgroundColor:[UIColor clearColor]];
}
- (void)setResumeModel:(AllResumeDataModel *)resumeModel indexPath:(NSIndexPath *)indexPath
{
//    [self resetStatues];
    if ( !resumeModel )
        return;
    _resumeModel = resumeModel;
    // 简历名称
    self.resumeNameLabel.text = resumeModel.ResumeName;
    // 校招简历图标
    if ( resumeModel.ResumeType.intValue == 2 )
    {
        self.schoolImageView.hidden = NO;
    }
    else
    {
        self.schoolImageView.hidden = YES;
    }
    // 默认简历图标
//    if ( resumeModel.Status.intValue == 1 )
//        self.defaultResumeImageView.hidden = NO;
//    else
    //        self.defaultResumeImageView.hidden = YES;
    if ( indexPath.row == 0 ) // 列表第一份简历为默认简历
        self.defaultResumeImageView.hidden = NO;
    else
        self.defaultResumeImageView.hidden = YES;
    // 简历是否可投状态
    if ( resumeModel.IsCompleteResume.intValue == 1 )
    {
        self.resumeStatusLabel.text = @"可投递";
        [self.resumeStatusLabel setTextColor:[UIColor colorWithHexString:@"6dbb56"]];
    }
    else
    {
        self.resumeStatusLabel.text = @"不可投递";
        [self.resumeStatusLabel setTextColor:[UIColor colorWithHexString:@"ff5252"]];
    }
    // 是否已经为默认简历
    if ( indexPath.row == 0 )
    {
        [self.resumeSetDefualtButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [self.resumeSetDefualtButton setTitle:@"已默认" forState:UIControlStateNormal];
    }
    else
    {
        [self.resumeSetDefualtButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [self.resumeSetDefualtButton setTitle:@"设为默认" forState:UIControlStateNormal];
    }
    // 简历被浏览数
    NSNumber *reviewNumber = resumeModel.Viewed;
    NSString *reviewStr = [NSString stringWithFormat:@"%@", reviewNumber];
    if ( reviewNumber.intValue > 99 )
        reviewStr = @"99+";
    [self.resumeReviewLabel setTitle:[NSString stringWithFormat:@"%@人看过", reviewStr] forState:UIControlStateNormal];
}
#pragma mark - getters methods
- (UIView *)fixdBackgroundView
{
    if ( !_fixdBackgroundView )
    {
        _fixdBackgroundView = [[UIView alloc] init];
        [_fixdBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_fixdBackgroundView.layer setCornerRadius:10.0 / CP_GLOBALSCALE];
        
    }
    return _fixdBackgroundView;
}
- (UIView *)fixdBackBackgroundView
{
    if ( !_fixdBackBackgroundView )
    {
        _fixdBackBackgroundView = [[UIView alloc] init];
        [_fixdBackBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"e4e3e9" alpha:1.0]];
        [_fixdBackBackgroundView.layer setCornerRadius:10.0 / CP_GLOBALSCALE];
    }
    return _fixdBackBackgroundView;
}
- (UILabel *)resumeNameLabel
{
    if ( !_resumeNameLabel )
    {
        _resumeNameLabel = [[UILabel alloc] init];
        [_resumeNameLabel setFont:[UIFont systemFontOfSize:42.0 / CP_GLOBALSCALE]];
        [_resumeNameLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        
    }
    return _resumeNameLabel;
}
- (UIImageView *)defaultResumeImageView
{
    if ( !_defaultResumeImageView )
    {
        _defaultResumeImageView = [[UIImageView alloc] init];
        [_defaultResumeImageView.layer setCornerRadius:10.0 / CP_GLOBALSCALE];
        _defaultResumeImageView.image = [UIImage imageNamed:@"ic_default"];
        _defaultResumeImageView.hidden = YES;
    }
    return _defaultResumeImageView;
}
- (UILabel *)resumeStatusLabel
{
    if ( !_resumeStatusLabel )
    {
        _resumeStatusLabel = [[UILabel alloc] init];
        [_resumeStatusLabel setFont:[UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE]];
    }
    return _resumeStatusLabel;
}
- (UIButton *)resumeReviewLabel
{
    if ( !_resumeReviewLabel )
    {
        _resumeReviewLabel = [[UIButton alloc] init];
        [_resumeReviewLabel.titleLabel setFont:[UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE]];
        [_resumeReviewLabel setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_resumeReviewLabel.layer setCornerRadius:10.0 / CP_GLOBALSCALE];
        [_resumeReviewLabel.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [_resumeReviewLabel.layer setBorderWidth:2.0 / CP_GLOBALSCALE];
    }
    return _resumeReviewLabel;
}
- (CPProfileResumeReviewButton *)resumeReviewButton
{
    if ( !_resumeReviewButton )
    {
        _resumeReviewButton = [CPProfileResumeReviewButton buttonWithType:UIButtonTypeCustom];
        [_resumeReviewButton.titleLabel setFont:[UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE]];
        [_resumeReviewButton setBackgroundColor:[UIColor colorWithHexString:@"288add"]];
        [_resumeReviewButton.layer setCornerRadius:10.0 / CP_GLOBALSCALE];
        [_resumeReviewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_resumeReviewButton setImage:[UIImage imageNamed:@"ic_preview"] forState:UIControlStateNormal];
    }
    return _resumeReviewButton;
}
- (UIButton *)resumeSetDefualtButton
{
    if ( !_resumeSetDefualtButton )
    {
        _resumeSetDefualtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resumeSetDefualtButton.titleLabel setFont:[UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE]];
        [_resumeSetDefualtButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0.0] forState:UIControlStateNormal];
        [_resumeSetDefualtButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"efeff4"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    }
    return _resumeSetDefualtButton;
}
- (CPProfileResumeButton *)resumeCopyButton
{
    if ( !_resumeCopyButton )
    {
        _resumeCopyButton = [CPProfileResumeButton buttonWithType:UIButtonTypeCustom];
        [_resumeCopyButton.titleLabel setFont:[UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE]];
        [_resumeCopyButton setTitle:@"复制" forState:UIControlStateNormal];
        [_resumeCopyButton setTitleColor:[UIColor colorFromHexCode:@"9d9d9d"] forState:UIControlStateNormal];
        [_resumeCopyButton setImage:[UIImage imageNamed:@"list_ic_copy"] forState:UIControlStateNormal];
        [_resumeCopyButton addTarget:self action:@selector(setButtonHighlightedBackground:) forControlEvents:UIControlEventTouchDown];
        [_resumeCopyButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchUpInside];
        [_resumeCopyButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchUpOutside];
        [_resumeCopyButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragExit];
        [_resumeCopyButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragEnter];
        [_resumeCopyButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragInside];
        [_resumeCopyButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragOutside];
        [_resumeCopyButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchCancel];
    }
    return _resumeCopyButton;
}
- (CPProfileResumeButton *)resumeDeleteButton
{
    if ( !_resumeDeleteButton )
    {
        _resumeDeleteButton = [CPProfileResumeButton buttonWithType:UIButtonTypeCustom];
        [_resumeDeleteButton.titleLabel setFont:[UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE]];
        [_resumeDeleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_resumeDeleteButton setTitleColor:[UIColor colorFromHexCode:@"9d9d9d"] forState:UIControlStateNormal];
        [_resumeDeleteButton setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
        [_resumeDeleteButton addTarget:self action:@selector(setButtonHighlightedBackground:) forControlEvents:UIControlEventTouchDown];
        [_resumeDeleteButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchUpInside];
        [_resumeDeleteButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchUpOutside];
        [_resumeDeleteButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragExit];
        [_resumeDeleteButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragEnter];
        [_resumeDeleteButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragInside];
        [_resumeDeleteButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragOutside];
        [_resumeDeleteButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchCancel];
    }
    return _resumeDeleteButton;
}
- (CPProfileResumeButton *)resumeEditButton
{
    if ( !_resumeEditButton )
    {
        _resumeEditButton = [CPProfileResumeButton buttonWithType:UIButtonTypeCustom];
        [_resumeEditButton.titleLabel setFont:[UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE]];
        [_resumeEditButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_resumeEditButton setTitleColor:[UIColor colorFromHexCode:@"9d9d9d"] forState:UIControlStateNormal];
        [_resumeEditButton setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
        [_resumeEditButton addTarget:self action:@selector(setButtonHighlightedBackground:) forControlEvents:UIControlEventTouchDown];
        [_resumeEditButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchUpInside];
        [_resumeEditButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchUpOutside];
        [_resumeEditButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragExit];
        [_resumeEditButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragEnter];
        [_resumeEditButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragInside];
        [_resumeEditButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchDragOutside];
        [_resumeEditButton addTarget:self action:@selector(setButtonNormalBackground:) forControlEvents:UIControlEventTouchCancel];
    }
    return _resumeEditButton;
}
- (void)setButtonNormalBackground:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
}
- (void)setButtonHighlightedBackground:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
}
- (UIView *)HorizontalSeparatorLine
{
    if ( !_HorizontalSeparatorLine )
    {
        _HorizontalSeparatorLine = [[UIView alloc] init];
        [_HorizontalSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _HorizontalSeparatorLine;
}
- (UIView *)verticalSeparatorLine
{
    if ( !_verticalSeparatorLine )
    {
        _verticalSeparatorLine = [[UIView alloc] init];
        [_verticalSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _verticalSeparatorLine;
}
- (UIView *)verticalSeparatorLine1
{
    if ( !_verticalSeparatorLine1 )
    {
        _verticalSeparatorLine1 = [[UIView alloc] init];
        [_verticalSeparatorLine1 setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _verticalSeparatorLine1;
}
- (UIView *)verticalSeparatorLine2
{
    if ( !_verticalSeparatorLine2 )
    {
        _verticalSeparatorLine2 = [[UIView alloc] init];
        [_verticalSeparatorLine2 setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _verticalSeparatorLine2;
}
- (UIImageView *)schoolImageView
{
    if ( !_schoolImageView )
    {
        _schoolImageView = [[UIImageView alloc] init];
        _schoolImageView.image = [UIImage imageNamed:@"resume_ic_edutab"];
        _schoolImageView.hidden = YES;
    }
    return _schoolImageView;
}
#pragma mark - setters methods
- (void)setResumeModel:(AllResumeDataModel *)resumeModel
{
}
@end
