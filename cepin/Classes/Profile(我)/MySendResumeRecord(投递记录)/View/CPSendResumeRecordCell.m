//
//  CPSendResumeRecordCell.m
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSendResumeRecordCell.h"
#import "NSDate-Utilities.h"
#import "TBTextUnit.h"
#import "CPCommon.h"
@interface CPSendResumeRecordCell ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *statueLabel;
@property (nonatomic, strong) SendReumeModel *resumeRecord;
@end

@implementation CPSendResumeRecordCell
#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
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
+ (instancetype)sendResumeRecordCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"resumeRecordCell";
    CPSendResumeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPSendResumeRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configCellWithResumeRecord:(SendReumeModel *)resumeRecord
{
    if ( !resumeRecord )
        return;
    
    _resumeRecord = resumeRecord;
    
    self.positionLabel.text = _resumeRecord.PositionName;
    self.companyLabel.text = [TBTextUnit formatSalary:_resumeRecord.Salary company:_resumeRecord.CompanyName city:_resumeRecord.Address];
    
    if ( resumeRecord.Viewed.intValue == 1 )
    {
        self.statueLabel.text = @"已查看";
        self.statueLabel.textColor = [UIColor colorWithHexString:@"6cbb56"];
        self.timeLabel.text =[NSDate cepinMMdd:_resumeRecord.ViewedDate];
    }
    else
    {
        self.statueLabel.text = @"未查看";
        self.statueLabel.textColor = [UIColor colorWithHexString:@"288add"];
        self.timeLabel.text =[NSDate cepinMMdd:_resumeRecord.ApplyDate];
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
        [_whiteBackgroundView addSubview:self.statueLabel];
        [_whiteBackgroundView addSubview:self.companyLabel];
        [_whiteBackgroundView addSubview:self.timeLabel];
        
        [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.positionLabel.font.pointSize ) );
            make.right.equalTo( self.statueLabel.mas_left );
        }];
        
        [self.statueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.positionLabel.mas_centerY );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( self.positionLabel );
            make.width.equalTo( @( self.statueLabel.font.pointSize * 3.5 ) );
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.statueLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.timeLabel.font.pointSize ) );
            make.width.equalTo( @( self.timeLabel.font.pointSize * 4.0 +5) );
        }];
        
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.timeLabel.mas_centerY );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.companyLabel.font.pointSize ) );
            make.right.equalTo( self.timeLabel.mas_left );
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
}- (UILabel *)companyLabel
{
    if ( !_companyLabel )
    {
        _companyLabel = [[UILabel alloc] init];
        [_companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_companyLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
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
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _timeLabel;
}
- (UILabel *)statueLabel
{
    if ( !_statueLabel )
    {
        _statueLabel = [[UILabel alloc] init];
        [_statueLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_statueLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _statueLabel;
}
@end
