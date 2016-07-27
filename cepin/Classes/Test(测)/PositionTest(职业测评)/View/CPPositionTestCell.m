//
//  CPPositionTestCell.m
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPositionTestCell.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface CPPositionTestCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *testImageView;
@property (nonatomic, strong) UILabel *testTitleLabel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *testDescribeLabel;
@property (nonatomic, strong) DynamicExamModelDTO *positonTestModel;

@end

@implementation CPPositionTestCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        
        [self.contentView addSubview:self.blackBackgroundView];
        [self.blackBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.timeLabel.mas_bottom );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}

+ (instancetype)positionTestCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"positionTestCell";
    CPPositionTestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPPositionTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)configCellWithPostionTestModel:(DynamicExamModelDTO *)positionTestModel
{
    if ( !positionTestModel )
        return;
    
    _positonTestModel = positionTestModel;
    
    [self.timeLabel setText:_positonTestModel.CreateDate];
    [self.testImageView sd_setImageWithURL:[NSURL URLWithString:_positonTestModel.ImgFilePath] placeholderImage:[UIImage imageNamed:@"loading_img"]];
    [self.testTitleLabel setText:_positonTestModel.Title];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_positonTestModel.Introduction];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_positonTestModel.Introduction length])];
    [self.testDescribeLabel setAttributedText:attStr];
}

#pragma mark - getters methods
- (UILabel *)timeLabel
{
    if ( !_timeLabel )
    {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setHidden:YES];
    }
    return _timeLabel;
}
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
- (UIView *)whiteBackgroundView
{
    if ( !_whiteBackgroundView )
    {
        _whiteBackgroundView = [[UIView alloc] init];
        [_whiteBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:1.0]];
        [_whiteBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_whiteBackgroundView.layer setMasksToBounds:YES];
        
        [_whiteBackgroundView addSubview:self.testImageView];
        [_whiteBackgroundView addSubview:self.testTitleLabel];
        [_whiteBackgroundView addSubview:self.testDescribeLabel];
        
        [self.testImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 500 / CP_GLOBALSCALE ) );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE);
        }];
        
        [self.testTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.testImageView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.testImageView.mas_left );
            make.height.equalTo( @( 42 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.testImageView.mas_right );
        }];
        
        [self.testDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.testTitleLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.testTitleLabel.mas_left );
            make.right.equalTo( self.testTitleLabel.mas_right );
            make.bottom.equalTo( _whiteBackgroundView.mas_bottom ).offset( -60 / CP_GLOBALSCALE );
        }];
    }
    return _whiteBackgroundView;
}
- (UIImageView *)testImageView
{
    if ( !_testImageView )
    {
        _testImageView = [[UIImageView alloc] init];
    }
    return _testImageView;
}
- (UILabel *)testTitleLabel
{
    if ( !_testTitleLabel )
    {
        _testTitleLabel = [[UILabel alloc] init];
        [_testTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_testTitleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _testTitleLabel;
}
- (CPPositionDetailDescribeLabel *)testDescribeLabel
{
    if ( !_testDescribeLabel )
    {
        _testDescribeLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_testDescribeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_testDescribeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_testDescribeLabel setNumberOfLines:2];
        [_testDescribeLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _testDescribeLabel;
}

@end
