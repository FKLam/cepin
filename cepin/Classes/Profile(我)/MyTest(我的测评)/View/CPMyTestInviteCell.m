//
//  CPMyTestInviteCell.m
//  cepin
//
//  Created by ceping on 16/1/16.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPMyTestInviteCell.h"
#import "CPMyPositionTestCell.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@interface CPMyTestInviteCell ()
@property (nonatomic, strong) DynamicExamModelDTO *examModel;
@end

@implementation CPMyTestInviteCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        
        [self.contentView addSubview:self.blackBackgroundView];
        [self.blackBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return self;
}
+ (instancetype)myTestInviteCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"myTestInviteCell";
    CPMyTestInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPMyTestInviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    return cell;
}

+ (instancetype)myPositionCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"myPositionCell";
    CPMyPositionTestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPMyPositionTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    return cell;
}
- (void)configCellWithExamModel:(DynamicExamModelDTO *)examModel
{
    if ( !examModel )
        return;
    
    _examModel = examModel;
    
    [self.positionLabel setText:[NSString stringWithFormat:@"%@", _examModel.ProductName]];
    [self.companyLabel setText:_examModel.CompanyShowName];
    [self.timeLabel setText:[NSString stringWithFormat:@"%@%@", @"截止时间 ：", _examModel.ExamEndTime]];

    if(_examModel.Status.intValue == 0){
        //还未开始做测聘
        //判断时间是否过期
        if([NSDate dataBeforeCurrentData:_examModel.ExamEndTime2]){
            //已经过期
            [self.testButton setTitle:@"已过期" forState:UIControlStateNormal];
            [self.testButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
            [self.testButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0.0] forState:UIControlStateNormal];
            [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0.0] forState:UIControlStateHighlighted];
            [self.testButton.layer setBorderColor:[UIColor colorWithHexString:@"9d9d9d"].CGColor];
            [self.testButton setUserInteractionEnabled:NO];
        }else{
            [self.testButton setTitle:@"开始测评" forState:UIControlStateNormal];
            [self.testButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            [self.testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateNormal];
            [self.testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"247ec9"] cornerRadius:0.0] forState:UIControlStateSelected];
            [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateHighlighted];
            [self.testButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
            [self.testButton setUserInteractionEnabled:YES];
            
        }
        
    }else if (_examModel.Status.intValue == 1) {
        //进行中
        if([NSDate dataBeforeCurrentData:_examModel.ExamEndTime2]){
            //已经过期
            [self.testButton setTitle:@"已过期" forState:UIControlStateNormal];
            [self.testButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
            [self.testButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0.0] forState:UIControlStateNormal];
            [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0.0] forState:UIControlStateHighlighted];
            [self.testButton.layer setBorderColor:[UIColor colorWithHexString:@"9d9d9d"].CGColor];
            [self.testButton setUserInteractionEnabled:NO];
        }else{
            [self.testButton setTitle:@"继续测评" forState:UIControlStateNormal];
            [self.testButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            [self.testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
            [self.testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateSelected];
            [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateHighlighted];
            [self.testButton.layer setBorderColor:[UIColor colorWithHexString:@"ff5252"].CGColor];
            [self.testButton setUserInteractionEnabled:YES];
        
        }
        
        }
        else
        {
            //已完成
            [self.testButton setTitle:@"已完成" forState:UIControlStateNormal];
            [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0.0] forState:UIControlStateNormal];
            [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0.0] forState:UIControlStateHighlighted];
            [_testButton setTitleColor:[UIColor colorWithHexString:@"6cbb56"] forState:UIControlStateNormal];
            [self.testButton.layer setBorderColor:[UIColor colorWithHexString:@"6cbb56"].CGColor];
            [self.testButton setUserInteractionEnabled:NO];
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
- (UIView *)whiteBackgroundView
{
    if ( !_whiteBackgroundView )
    {
        _whiteBackgroundView = [[UIView alloc] init];
        [_whiteBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:1.0]];
        [_whiteBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_whiteBackgroundView.layer setMasksToBounds:YES];
        
        [_whiteBackgroundView addSubview:self.positionLabel];
        [_whiteBackgroundView addSubview:self.companyLabel];
        [_whiteBackgroundView addSubview:self.timeLabel];
        [_whiteBackgroundView addSubview:self.testButton];
        
        [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.positionLabel.font.pointSize ) );
            make.right.equalTo( self.testButton.mas_left );
        }];
        
        [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo( self.positionLabel.mas_centerY );
            make.width.equalTo( @( 250 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 90 / CP_GLOBALSCALE ) );
        }];
        
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.positionLabel.mas_left );
            make.height.equalTo( @( self.companyLabel.font.pointSize ) );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.top.equalTo( self.positionLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( self.companyLabel.mas_left );
            make.height.equalTo( @( self.timeLabel.font.pointSize ) );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        
        
    }
    return _whiteBackgroundView;
}
- (UILabel *)positionLabel
{
    if ( !_positionLabel )
    {
        _positionLabel = [[UILabel alloc] init];
        [_positionLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _positionLabel;
}
- (UILabel *)companyLabel
{
    if ( !_companyLabel )
    {
        _companyLabel = [[UILabel alloc] init];
        [_companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_companyLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
    }
    return _companyLabel;
}
- (UILabel *)timeLabel
{
    if ( !_timeLabel )
    {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_timeLabel setText:@"截止时间 : "];
    }
    return _timeLabel;
}
- (UIButton *)testButton
{
    if ( !_testButton )
    {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testButton setTitle:@"继续测评" forState:UIControlStateNormal];
        [_testButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_testButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_testButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_testButton.layer setMasksToBounds:YES];
        [_testButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
    }
    return _testButton;
}
@end
