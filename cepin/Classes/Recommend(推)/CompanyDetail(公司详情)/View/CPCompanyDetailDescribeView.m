//
//  CPCompanyDetailDescribeView.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyDetailDescribeView.h"
#import "CPCommon.h"
@interface CPCompanyDetailDescribeView ()

@property (nonatomic, strong) UIImageView *companyLogo;
@property (nonatomic, strong) UILabel *companyNameLabel;
@property (nonatomic, strong) UILabel *companyDescribeLabel;
@property (nonatomic, strong) NSDictionary *companyDict;
@end

@implementation CPCompanyDetailDescribeView

#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [self addSubview:self.companyLogo];
        [self.companyLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 200 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 200 / CP_GLOBALSCALE ) );
        }];
        [self addSubview:self.companyNameLabel];
        [self addSubview:self.companyDescribeLabel];
        [self.companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.companyLogo.mas_right ).offset( 30 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.companyDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyNameLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( self.companyNameLabel.mas_left );
            make.right.equalTo( self.companyNameLabel.mas_right );
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
    NSString *logoURLStr = nil;
    if ( ![[_companyDict valueForKey:@"Logo"] isKindOfClass:[NSNull class]])
        logoURLStr = [_companyDict valueForKey:@"Logo"];
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:logoURLStr] placeholderImage:[UIImage imageNamed:@"null_logo"]];
    NSString *shortName =[_companyDict valueForKey:@"Shortname"];
    if (![shortName isKindOfClass:[NSNull class]] && nil != shortName && NULL != shortName && ![@"" isEqualToString:shortName]) {
        [self.companyNameLabel setText:shortName];
    }else{
        [self.companyNameLabel setText:[_companyDict valueForKey:@"CompanyName"]];
    }
    
    NSString *pulseContent  = [_companyDict valueForKey:@"PulseEmployer"];
    if(pulseContent && nil != pulseContent && NULL != pulseContent && ![pulseContent isKindOfClass:NSNull.class]){
        [self.companyDescribeLabel setText:pulseContent];
    }
}
#pragma mark - getter methods
- (UIImageView *)companyLogo
{
    if ( !_companyLogo )
    {
        _companyLogo = [[UIImageView alloc] init];
        _companyLogo.image = [UIImage imageNamed:@"null_logo"];
        //是否设置边框以及是否可见
        [_companyLogo.layer setMasksToBounds:YES];
        CGFloat cornerRadius = 200/CP_GLOBALSCALE *0.5;
         [_companyLogo.layer setCornerRadius:cornerRadius];
        [_companyLogo.layer setBorderWidth:2.0/CP_GLOBALSCALE];
        //设置边框线的颜色
        [_companyLogo.layer setBorderColor:[[UIColor colorWithHexString:@"e1e1e3"] CGColor]];
        
    }
    return _companyLogo;
}
- (UILabel *)companyNameLabel
{
    if ( !_companyNameLabel )
    {
        _companyNameLabel = [[UILabel alloc] init];
        [_companyNameLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_companyNameLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_companyNameLabel setNumberOfLines:0];
        
    }
    return _companyNameLabel;
}
- (UILabel *)companyDescribeLabel
{
    if ( !_companyDescribeLabel )
    {
        _companyDescribeLabel = [[UILabel alloc] init];
        [_companyDescribeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_companyDescribeLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_companyDescribeLabel setNumberOfLines:2];
    }
    return _companyDescribeLabel;
}
@end
