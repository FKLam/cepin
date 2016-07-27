//
//  CPProfileCompanyMessageCell.m
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPProfileCompanyMessageCell.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@interface CPProfileCompanyMessageCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;

@property (nonatomic, strong) DynamicSystemModelDTO *messageModel;
@end

@implementation CPProfileCompanyMessageCell

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
+ (instancetype)companyMessageCellWithTabelView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"companyMessageCell";
    CPProfileCompanyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPProfileCompanyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configeCellWith:(DynamicSystemModelDTO *)messageModel
{
    if ( !messageModel )
        return;
    
    _messageModel = messageModel;
    
    [self.testTitleLabel setText:_messageModel.Title];
    [self.timeLabel setText:[NSDate cepinMMddHHddFromString:_messageModel.CreateDate]];
    
//    cell.lableTime.text = bean.CreateDate;
//    cell.lableTitle.text = bean.Title;
//    cell.subLabel.text = bean.Content;
}



-(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

#pragma mark - getter methods
- (UILabel *)timeLabel
{
    if ( !_timeLabel )
    {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_timeLabel setTextAlignment:NSTextAlignmentLeft];
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
        
        [_whiteBackgroundView addSubview:self.testTitleLabel];
        
        [self.testTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
//            make.height.equalTo( @( 50 ) );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        
        [_whiteBackgroundView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.testTitleLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.testTitleLabel.mas_left );
//            make.bottom.equalTo( _whiteBackgroundView.mas_bottom ).offset( -60 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return _whiteBackgroundView;
}
- (UILabel *)testTitleLabel
{
    if ( !_testTitleLabel )
    {
        _testTitleLabel = [[UILabel alloc] init];
        [_testTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_testTitleLabel setNumberOfLines:0];
        [_testTitleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_testTitleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _testTitleLabel;
}
@end
