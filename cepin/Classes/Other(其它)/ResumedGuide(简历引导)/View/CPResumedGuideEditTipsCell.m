//
//  CPResumedGuideEditTipsCell.m
//  cepin
//
//  Created by ceping on 16/1/19.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumedGuideEditTipsCell.h"
#import "CPCommon.h"
@interface CPResumedGuideEditTipsCell ()
@property (nonatomic, strong) UIView *topSeparatorLine;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *tipsView;

@end

@implementation CPResumedGuideEditTipsCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        
        [self.contentView addSubview:self.tipsView];
        [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
//            make.height.equalTo( @( ( 60 + 42 + 42 + 18 * 2 + 60 ) / CP_GLOBALSCALE ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
        [self.contentView addSubview:self.topSeparatorLine];
        [self.topSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.top.equalTo( self.mas_top );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [self.contentView addSubview:self.separatorLine];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return self;
}

+ (instancetype)guideEditTipsCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"resumedGuideEditTipsCell";
    CPResumedGuideEditTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPResumedGuideEditTipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    BOOL isShowTopSeparatorLine = YES;
    CGFloat leftLease = 40 / CP_GLOBALSCALE;
    if ( self.viewHeight > 60 / CP_GLOBALSCALE )
    {
        leftLease = 0;
        isShowTopSeparatorLine = NO;
    }
    else
    {
        leftLease = 40 / CP_GLOBALSCALE;
    }
    [self.topSeparatorLine setHidden:isShowTopSeparatorLine];
    [self.topSeparatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( self.mas_left );
        make.top.equalTo( self.mas_top );
        make.right.equalTo( self.mas_right );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
    }];
    [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( self.mas_left ).offset( leftLease );
        make.bottom.equalTo( self.mas_bottom );
        make.right.equalTo( self.mas_right );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
    }];
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
        [paragrapHStyle setLineSpacing:18 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithString:tipsStr attributes:@{
                                                                                                                    NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE],
                                                                                                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"],
                                                                                                                    NSParagraphStyleAttributeName : paragrapHStyle
                                                                                                                    }];
        [tipsLabel setAttributedText:attStrM];
        
        [_tipsView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _tipsView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _tipsView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _tipsView.mas_right ).offset( -20 / CP_GLOBALSCALE );
            make.bottom.equalTo( _tipsView.mas_bottom ).offset( -60 / CP_GLOBALSCALE );
        }];
    }
    return _tipsView;
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
- (UIView *)topSeparatorLine
{
    if ( !_topSeparatorLine )
    {
        _topSeparatorLine = [[UIView alloc] init];
        [_topSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3d6"]];
    }
    return _topSeparatorLine;
}
@end
