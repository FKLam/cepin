//
//  CPSocailRsumeReviewInforView.m
//  cepin
//
//  Created by ceping on 16/2/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSocailRsumeReviewInforView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface CPSocailRsumeReviewInforView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressStaticLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *oneWordStaticLabel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *oneWordLabel;
@property (nonatomic, strong) UILabel *marriageLabel;
@property (nonatomic, strong) UILabel *faceStaticLabel;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@property (nonatomic, strong) UILabel *idCardLabel;
@property (nonatomic, strong) UILabel *idCardStaticLabel;
@end
@implementation CPSocailRsumeReviewInforView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.titleLabel.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.idCardStaticLabel];
        [self addSubview:self.idCardLabel];
        [self.idCardStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( separatorLine.mas_left );
        }];
        [self.idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.idCardStaticLabel.mas_top );
            make.left.equalTo( self.idCardStaticLabel.mas_right );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        
        [self addSubview:self.addressStaticLabel];
        [self addSubview:self.addressLabel];
        [self.addressStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.idCardStaticLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.idCardStaticLabel.mas_left );
        }];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.addressStaticLabel.mas_top );
            make.left.equalTo( self.addressStaticLabel.mas_right );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.oneWordStaticLabel];
        [self addSubview:self.oneWordLabel];
        [self.oneWordStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.addressStaticLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( separatorLine.mas_left );
        }];
        [self.oneWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.oneWordStaticLabel.mas_top );
            make.left.equalTo( self.oneWordStaticLabel.mas_right );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.secondSeparatorLine];
        [self.secondSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.oneWordLabel.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.marriageLabel];
        [self addSubview:self.faceStaticLabel];
        [self.marriageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.secondSeparatorLine.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.left.equalTo( self.secondSeparatorLine.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.faceStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.marriageLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.marriageLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        UIView *separatorEndLine = [[UIView alloc] init];
        [separatorEndLine setBackgroundColor:[UIColor colorWithHexString:@"e6e6ea"]];
        [self addSubview:separatorEndLine];
        [separatorEndLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.mas_bottom );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 6 / CP_GLOBALSCALE ) );
        }];
    }
    return self;
}
- (void)configWithResume:(ResumeNameModel *)resumeModel
{
    [self.addressLabel setText:resumeModel.Region];
    [self.idCardLabel setText:resumeModel.IdCardNumber];
    if ( resumeModel.Introduces )
    {
        NSString *temStr = resumeModel.Introduces;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}];
        [self.oneWordLabel setAttributedText:attStr];
    }
    else
    {
        [self.secondSeparatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.oneWordStaticLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    //婚姻状况（0 未知 1、未婚 2、已婚）
    NSNumber *marriageNumber = resumeModel.Marital;
    NSString *marriageStr = nil;
    if ( 1 == [marriageNumber intValue] )
    {
        marriageStr = @"未婚";
    }
    else if ( 2 == [marriageNumber intValue] )
    {
        marriageStr = @"已婚";
    }
    else
    {
        marriageStr = @"未婚";
    }
    [self setLabel:self.marriageLabel content:marriageStr];
    [self setLabel:self.faceStaticLabel content:resumeModel.Politics];
    [self resetFrameWithResume:resumeModel];
}
- (void)setLabel:(UILabel *)label content:(NSString *)content
{
    if ( !content || 0 == [content length] )
    {
        return;
    }
    NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] init];
    NSString *staticStr = label.text;
    [attStrM appendAttributedString:[[NSAttributedString alloc] initWithString:staticStr attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHexString:@"707070"] }]];
    [attStrM appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"] }]];
    [label setText:@""];
    [label setAttributedText:attStrM];
}
- (void)resetFrameWithResume:(ResumeNameModel *)resumeModel
{
    if ( !resumeModel.Politics || 0 == [resumeModel.Politics length] )
    {
        [self.faceStaticLabel setHidden:YES];
        [self.faceStaticLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.marriageLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.marriageLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 0 ) );
        }];
    }
    else
    {
        [self.faceStaticLabel setHidden:NO];
    }
}
#pragma mark - getter methods
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setText:@"基本信息"];
    }
    return _titleLabel;
}
- (UILabel *)addressStaticLabel
{
    if ( !_addressStaticLabel )
    {
        _addressStaticLabel = [[UILabel alloc] init];
        [_addressStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_addressStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_addressStaticLabel setText:@"现居住地        "];
    }
    return _addressStaticLabel;
}
- (UILabel *)addressLabel
{
    if ( !_addressLabel )
    {
        _addressLabel = [[UILabel alloc] init];
        [_addressLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_addressLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _addressLabel;
}
- (UILabel *)idCardStaticLabel
{
    if ( !_idCardStaticLabel )
    {
        _idCardStaticLabel = [[UILabel alloc] init];
        [_idCardStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_idCardStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_idCardStaticLabel setText:@"身份证号        "];
    }
    return _idCardStaticLabel;
}
- (UILabel *)idCardLabel
{
    if ( !_idCardLabel )
    {
        _idCardLabel = [[UILabel alloc] init];
        [_idCardLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_idCardLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _idCardLabel;
}
- (UILabel *)oneWordStaticLabel
{
    if ( !_oneWordStaticLabel )
    {
        _oneWordStaticLabel = [[UILabel alloc] init];
        [_oneWordStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_oneWordStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_oneWordStaticLabel setText:@"一句话优势    "];
    }
    return _oneWordStaticLabel;
}
- (CPPositionDetailDescribeLabel *)oneWordLabel
{
    if ( !_oneWordLabel )
    {
        _oneWordLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_oneWordLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_oneWordLabel setVerticalAlignment:VerticalAlignmentTop];
        [_oneWordLabel setNumberOfLines:0];
    }
    return _oneWordLabel;
}
- (UILabel *)marriageLabel
{
    if ( !_marriageLabel )
    {
        _marriageLabel = [[UILabel alloc] init];
        [_marriageLabel setText:@"婚姻状况       "];
        [_marriageLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _marriageLabel;
}
- (UILabel *)faceStaticLabel
{
    if ( !_faceStaticLabel )
    {
        _faceStaticLabel = [[UILabel alloc] init];
        [_faceStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_faceStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_faceStaticLabel setText:@"政治面貌       "];
    }
    return _faceStaticLabel;
}
- (UIView *)secondSeparatorLine
{
    if ( !_secondSeparatorLine )
    {
        _secondSeparatorLine = [[UIView alloc] init];
        [_secondSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _secondSeparatorLine;
}
@end