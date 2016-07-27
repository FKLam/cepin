//
//  CPCompanyInformationView.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyInformationView.h"
#import "CPCommon.h"
#import "CPPositionDetailDescribeLabel.h"
@interface CPCompanyInformationView ()

@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *requireLabel;

@property (nonatomic, strong) CPPositionDetailDescribeLabel *scaleLabel;
@property (nonatomic, strong) UILabel *natureLabel;
@property (nonatomic, strong) UILabel *listLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UILabel *industryLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *websiteLabel;

@property (nonatomic, strong) CPPositionDetailDescribeLabel *scaleContentLabel;
@property (nonatomic, strong) UILabel *natureContentLabel;
@property (nonatomic, strong) UILabel *listContentLabel;
@property (nonatomic, strong) UILabel *placeContentLabel;
@property (nonatomic, strong) UILabel *industryContentLabel;
@property (nonatomic, strong) UILabel *addressContentLabel;
@property (nonatomic, strong) UILabel *websiteContentLabel;
@property (nonatomic, strong) NSDictionary *companyDict;
@end

@implementation CPCompanyInformationView

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
        [self addSubview:self.scaleLabel];
        [self addSubview:self.natureLabel];
        [self addSubview:self.listLabel];
        [self addSubview:self.placeLabel];
        [self addSubview:self.industryLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.websiteLabel];
        
        [self addSubview:self.scaleContentLabel];
        [self addSubview:self.natureContentLabel];
        [self addSubview:self.listContentLabel];
        [self addSubview:self.placeContentLabel];
        [self addSubview:self.industryContentLabel];
        [self addSubview:self.addressContentLabel];
        [self addSubview:self.websiteContentLabel];
        
        [self.scaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.requireLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
        }];
        [self.natureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.scaleLabel.mas_top );
            make.left.equalTo( @( kScreenWidth / 2.0 ) );
            make.height.equalTo( self.scaleLabel );
        }];
        [self.listLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.scaleLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( self.scaleLabel.mas_left );
            make.height.equalTo( self.scaleLabel );
        }];
        [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.natureLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( self.natureLabel.mas_left );
            make.height.equalTo( self.scaleLabel );
            make.width.equalTo(@( 108 / CP_GLOBALSCALE));
        }];
        [self.industryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.listLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( self.scaleLabel.mas_left );
            make.height.equalTo( self.scaleLabel );
        }];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.industryContentLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( self.scaleLabel.mas_left );
            make.height.equalTo( self.scaleLabel );
        }];
        [self.websiteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.addressContentLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( self.scaleLabel.mas_left );
            make.height.equalTo( self.scaleLabel );
        }];
        [self.scaleContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.scaleLabel.mas_top );
            make.left.equalTo( self.scaleLabel.mas_right );
            make.right.equalTo( self.natureLabel.mas_left ).offset( 20 / CP_GLOBALSCALE );
        }];
        [self.natureContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.natureLabel.mas_top );
            make.left.equalTo( self.natureLabel.mas_right );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -20 / CP_GLOBALSCALE );
        }];
        [self.listContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.listLabel.mas_top );
            make.left.equalTo( self.listLabel.mas_right );
            make.right.equalTo( self.placeLabel.mas_left ).offset( 20 / CP_GLOBALSCALE );
        }];
        [self.placeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.placeLabel.mas_top );
            make.left.equalTo( self.placeLabel.mas_right );
            make.right.equalTo( self.mas_right ).offset( -20 / CP_GLOBALSCALE );
        }];
        [self.industryContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.industryLabel.mas_top );
            make.left.equalTo( self.industryLabel.mas_right );
            make.right.equalTo( self.mas_right ).offset( -20 / CP_GLOBALSCALE );
        }];
        [self.addressContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.addressLabel.mas_top );
            make.left.equalTo( self.addressLabel.mas_right );
            make.right.equalTo( self.mas_right ).offset( -20 / CP_GLOBALSCALE );
        }];
        [self.websiteContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.websiteLabel.mas_top );
            make.left.equalTo( self.websiteLabel.mas_right );
            make.right.equalTo( self.mas_right ).offset( -20 / CP_GLOBALSCALE );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}
- (void)configWithDict:(NSDictionary *)companyDict
{
    _companyDict = companyDict;
    [self.scaleContentLabel setText:[_companyDict valueForKey:@"CompanySize"]];
    NSString *nature = [_companyDict valueForKey:@"CompanyNature"];
    if ( [nature isKindOfClass:[NSNull class]]) {
        nature = @"";
    }
    [self.natureContentLabel setText:nature];
    NSString *isListedFlag = [_companyDict valueForKey:@"IsListedCompany"];
    NSString *isListedString = @"未上市";
    if ( 1 == [isListedFlag intValue] )
    {
        isListedString = @"新三板";
    }
    else if ( 2 == [isListedFlag intValue] )
    {
        isListedString = @"A股";
    }
    else if ( 3 == [isListedFlag intValue] )
    {
        isListedString = @"B股";
    }
    else if ( 4 == [isListedFlag intValue] )
    {
        isListedString = @"H股";
    }
    else if ( 5 == [isListedFlag intValue] )
    {
        isListedString = @"其他";
    }
    [self.listContentLabel setText:isListedString];
    [self.placeContentLabel setText:[_companyDict valueForKey:@"CompanyCity"]];
    [self.industryContentLabel setText:[_companyDict valueForKey:@"Industry"]];
    NSString *Address = [_companyDict valueForKey:@"Address"];
    if ( [Address isKindOfClass:[NSNull class]]) {
        Address = @"";
    }
    [self.addressContentLabel setText:@""];
    [self.addressContentLabel setText:Address];
    NSString *webURLStr = nil;
    if ( ![[_companyDict valueForKey:@"WebSiteUrl"] isKindOfClass:[NSNull class]]){
        webURLStr = [_companyDict valueForKey:@"WebSiteUrl"];
    }else{
        webURLStr = @"";
    }
    [self.websiteContentLabel setText:webURLStr];
    if ( !webURLStr || [@"" isEqualToString:webURLStr])
        [self.websiteLabel setHidden:YES];
}

-(void)resetView{
    [self.addressContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.addressLabel.mas_top );
        make.left.equalTo( self.addressLabel.mas_right );
        make.right.equalTo( self.mas_right ).offset( -20 / CP_GLOBALSCALE );
    }];
}

#pragma mark - getter methods
- (UILabel *)requireLabel
{
    if ( !_requireLabel )
    {
        _requireLabel = [[UILabel alloc] init];
        [_requireLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_requireLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_requireLabel setText:@"企业信息"];
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
- (CPPositionDetailDescribeLabel *)scaleLabel
{
    if ( !_scaleLabel )
    {
        _scaleLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_scaleLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_scaleLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_scaleLabel setText:@"规模 : "];
        [_scaleLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _scaleLabel;
}
- (UILabel *)natureLabel
{
    if ( !_natureLabel )
    {
        _natureLabel = [[UILabel alloc] init];
        [_natureLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_natureLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_natureLabel setText:@"性质 : "];
    }
    return _natureLabel;
}
- (UILabel *)listLabel
{
    if ( !_listLabel )
    {
        _listLabel = [[UILabel alloc] init];
        [_listLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_listLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_listLabel setText:@"上市 : "];
    }
    return _listLabel;
}
- (UILabel *)placeLabel
{
    if ( !_placeLabel )
    {
        _placeLabel = [[UILabel alloc] init];
        [_placeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_placeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_placeLabel setText:@"地点 : "];
    }
    return _placeLabel;
}
- (UILabel *)industryLabel
{
    if ( !_industryLabel )
    {
        _industryLabel = [[UILabel alloc] init];
        [_industryLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_industryLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_industryLabel setText:@"行业 : "];
    }
    return _industryLabel;
}
- (UILabel *)addressLabel
{
    if ( !_addressLabel )
    {
        _addressLabel = [[UILabel alloc] init];
        [_addressLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_addressLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_addressLabel setText:@"地址 : "];
    }
    return _addressLabel;
}
- (UILabel *)websiteLabel
{
    if ( !_websiteLabel )
    {
        _websiteLabel = [[UILabel alloc] init];
        [_websiteLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_websiteLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_websiteLabel setText:@"官网 : "];
    }
    return _websiteLabel;
}
- (UILabel *)websiteContentLabel
{
    if ( !_websiteContentLabel )
    {
        _websiteContentLabel = [[UILabel alloc] init];
        [_websiteContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_websiteContentLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_websiteContentLabel setNumberOfLines:0];
    }
    return _websiteContentLabel;
}
- (UILabel *)addressContentLabel
{
    if ( !_addressContentLabel )
    {
        _addressContentLabel = [[UILabel alloc] init];
        [_addressContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_addressContentLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_addressContentLabel setNumberOfLines:0];
    }
    return _addressContentLabel;
}
- (UILabel *)industryContentLabel
{
    if ( !_industryContentLabel )
    {
        _industryContentLabel = [[UILabel alloc] init];
        [_industryContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_industryContentLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_industryContentLabel setNumberOfLines:0];
    }
    return _industryContentLabel;
}
- (UILabel *)placeContentLabel
{
    if ( !_placeContentLabel )
    {
        _placeContentLabel = [[UILabel alloc] init];
        [_placeContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_placeContentLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
    }
    return _placeContentLabel;
}
- (UILabel *)listContentLabel
{
    if ( !_listContentLabel )
    {
        _listContentLabel = [[UILabel alloc] init];
        [_listContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_listContentLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
    }
    return _listContentLabel;
}
- (UILabel *)natureContentLabel
{
    if ( !_natureContentLabel )
    {
        _natureContentLabel = [[UILabel alloc] init];
        [_natureContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_natureContentLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_natureContentLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _natureContentLabel;
}
- (CPPositionDetailDescribeLabel *)scaleContentLabel
{
    if ( !_scaleContentLabel )
    {
        _scaleContentLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_scaleContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_scaleContentLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_scaleContentLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _scaleContentLabel;
}

@end
