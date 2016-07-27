//
//  CPCompanyDetailRequireView.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPositionDetailRequireView.h"
#import "CPCommon.h"
@interface CPPositionDetailRequireView ()

@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *requireLabel;

@property (nonatomic, strong) UILabel *natureLabel;
@property (nonatomic, strong) UILabel *functionLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *majorLabel;

@property (nonatomic, strong) UILabel *natureContentLabel;
@property (nonatomic, strong) UILabel *functionContentLabel;
@property (nonatomic, strong) UILabel *numberContentLabel;
@property (nonatomic, strong) UILabel *majorContentLabel;
@property (nonatomic, strong) NSDictionary *positionDetail;
@end

@implementation CPPositionDetailRequireView

#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        // 搜索标题 高亮图标
        [self addSubview:self.titleBlueLineImageView];
        [self.titleBlueLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 42 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 42 / CP_GLOBALSCALE ) );
        }];
        
        // 热门搜索标题
        [self addSubview:self.requireLabel];
        [self.requireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.requireLabel.font.pointSize ) );
        }];
        
        [self addSubview:self.natureLabel];
        [self addSubview:self.functionLabel];
        [self addSubview:self.numberLabel];
        [self addSubview:self.majorLabel];
        
        [self addSubview:self.natureContentLabel];
        [self addSubview:self.functionContentLabel];
        [self addSubview:self.numberContentLabel];
        [self addSubview:self.majorContentLabel];
        
        [self.natureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.requireLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @(self.natureLabel.font.pointSize ) );
        }];
        
        [self.functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.natureLabel.mas_top );
            make.left.equalTo( @( kScreenWidth / 2.0 ) );
            make.height.equalTo( @( self.functionLabel.font.pointSize ) );
        }];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.natureLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( self.natureLabel );
        }];
        
        [self.majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.numberLabel.mas_top );
            make.left.equalTo( self.functionLabel.mas_left );
            make.height.equalTo( self.natureLabel );
        }];
        
        [self.natureContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.natureLabel.mas_bottom );
            make.left.equalTo( self.natureLabel.mas_right );
            make.height.equalTo( self.natureLabel );
            make.right.equalTo( self.functionLabel.mas_left ).offset( -20 / CP_GLOBALSCALE );
        }];
        
        [self.functionContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.functionLabel.mas_centerY );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.left.equalTo( self.functionLabel.mas_right );
            make.height.equalTo( self.functionContentLabel );
        }];
        
        [self.numberContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.numberLabel.mas_bottom );
            make.left.equalTo( self.numberLabel.mas_right );
            make.height.equalTo( self.numberLabel );
            make.right.equalTo( self.majorLabel.mas_left ).offset( -20 / CP_GLOBALSCALE );
        }];
        
        [self.majorContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.majorLabel.mas_bottom );
            make.left.equalTo( self.majorLabel.mas_right );
            make.height.equalTo( self.majorLabel );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return self;
}
- (void)configWithPosition:(NSDictionary *)position
{
    _positionDetail = position;
    [self.natureContentLabel setText:[_positionDetail valueForKey:@"PositionNature"]];
    [self.functionContentLabel setText:[_positionDetail valueForKey:@"JobFunction"]];
    [self.numberContentLabel setText:[_positionDetail valueForKey:@"PersonNumber"]];
    NSString *majorStr = @"";
    if ( ![[_positionDetail valueForKey:@"Major"] isKindOfClass:[NSNull class]] )
        majorStr = [_positionDetail valueForKey:@"Major"];
    if(nil == majorStr || NULL == majorStr || [majorStr isEqualToString:@""] || [majorStr isKindOfClass:[NSNull class]]){
        [_majorLabel setHidden:YES];
    }else{
         [self.majorContentLabel setText:majorStr];
    }
   
}
#pragma mark - getter methods
- (UILabel *)requireLabel
{
    if ( !_requireLabel )
    {
        _requireLabel = [[UILabel alloc] init];
        [_requireLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_requireLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_requireLabel setText:@"职位要求"];
    }
    return _requireLabel;
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
- (UILabel *)natureLabel
{
    if ( !_natureLabel )
    {
        _natureLabel = [[UILabel alloc] init];
        [_natureLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_natureLabel setText:@"性质 : "];
        [_natureLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    return _natureLabel;
}
- (UILabel *)functionLabel
{
    if ( !_functionLabel )
    {
        _functionLabel = [[UILabel alloc] init];
        [_functionLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_functionLabel setText:@"职能 : "];
        [_functionLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    return _functionLabel;
}
- (UILabel *)numberLabel
{
    if ( !_numberLabel )
    {
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_numberLabel setText:@"人数 : "];
        [_numberLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    return _numberLabel;
}
- (UILabel *)majorLabel
{
    if ( !_majorLabel )
    {
        _majorLabel = [[UILabel alloc] init];
        [_majorLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_majorLabel setText:@"专业 : "];
        [_majorLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    return _majorLabel;
}
- (UILabel *)natureContentLabel
{
    if ( !_natureContentLabel )
    {
        _natureContentLabel = [[UILabel alloc] init];
        [_natureContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_natureContentLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_natureContentLabel setTextAlignment:NSTextAlignmentLeft];
        [_natureContentLabel setText:@""];
    }
    return _natureContentLabel;
}
- (UILabel *)functionContentLabel
{
    if ( !_functionContentLabel )
    {
        _functionContentLabel = [[UILabel alloc] init];
        [_functionContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_functionContentLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_functionContentLabel setText:@""];
        [_functionContentLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _functionContentLabel;
}
- (UILabel *)numberContentLabel
{
    if ( !_numberContentLabel )
    {
        _numberContentLabel = [[UILabel alloc] init];
        [_numberContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_numberContentLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_numberContentLabel setText:@""];
        [_numberContentLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _numberContentLabel;
}
- (UILabel *)majorContentLabel
{
    if ( !_majorContentLabel )
    {
        _majorContentLabel = [[UILabel alloc] init];
        [_majorContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_majorContentLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_majorContentLabel setText:@""];
        [_majorContentLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _majorContentLabel;
}
@end
