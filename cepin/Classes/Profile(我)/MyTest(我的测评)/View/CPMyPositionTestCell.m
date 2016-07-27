//
//  CPPositionTestCell.m
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPMyPositionTestCell.h"
#import "CPCommon.h"
@interface CPMyPositionTestCell ()
@property (nonatomic, strong) UILabel *mytimeLabel;
@property (nonatomic, strong) UIView *myblackBackgroundView;
@property (nonatomic, strong) UIView *mywhiteBackgroundView;
@property (nonatomic, strong) UIImageView *testImageView;
@property (nonatomic, strong) UILabel *testTitleLabel;
@property (nonatomic, strong) UILabel *testExamSatusLabel;
@property (nonatomic, strong) DynamicExamModelDTO *positonTestModel;

@end

@implementation CPMyPositionTestCell

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
            make.top.equalTo( self.mas_top).offset(40/CP_GLOBALSCALE);
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom);
        }];
        
    }
    return self;
}

+ (instancetype)positionTestCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"positionTestCell";
    CPMyPositionTestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPMyPositionTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)configCellWithMyPostionTestModel:(DynamicExamModelDTO *)positionTestModel
{
    if ( !positionTestModel )
        return;
    _positonTestModel = positionTestModel;
    [self.testImageView sd_setImageWithURL:[NSURL URLWithString:_positonTestModel.Icon] placeholderImage:[UIImage imageNamed:@"loading_img"]];
    [self.testTitleLabel setText:_positonTestModel.Title];
    if ( _positonTestModel.ExamStatus.intValue == 2 )
    {
        [self.testExamSatusLabel setText:@"查看报告"];
        [_mytimeLabel setText:_positonTestModel.ExamFinishTime];
        [_testExamSatusLabel setTextColor:[UIColor colorWithHexString:@"6cbb56"]];
        [_mytimeLabel setHidden:NO];
    }
    else
    {
        [self.testExamSatusLabel setText:@"继续测评"];
        [_testExamSatusLabel setTextColor:[UIColor colorWithHexString:@"ff5252"]];
        [_mytimeLabel setHidden:YES];
    }
}
#pragma mark - getters methods
- (UILabel *)mytimeLabel
{
    if ( !_mytimeLabel )
    {
        _mytimeLabel = [[UILabel alloc] init];
        [_mytimeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_mytimeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_mytimeLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _mytimeLabel;
}
- (UIView *)blackBackgroundView
{
    if ( !_myblackBackgroundView )
    {
        _myblackBackgroundView = [[UIView alloc] init];
        [_myblackBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.04]];
        [_myblackBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_myblackBackgroundView.layer setMasksToBounds:YES];
        
        [_myblackBackgroundView addSubview:self.whiteBackgroundView];
        [self.whiteBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _myblackBackgroundView.mas_top );
            make.left.equalTo( _myblackBackgroundView.mas_left );
            make.bottom.equalTo( _myblackBackgroundView.mas_bottom ).offset( -6 / CP_GLOBALSCALE );
            make.right.equalTo( _myblackBackgroundView.mas_right );
        }];
    }
    return _myblackBackgroundView;
}
- (UIView *)whiteBackgroundView
{
    if ( !_mywhiteBackgroundView )
    {
        _mywhiteBackgroundView = [[UIView alloc] init];
        [_mywhiteBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:1.0]];
        [_mywhiteBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_mywhiteBackgroundView.layer setMasksToBounds:YES];
        
        [_mywhiteBackgroundView addSubview:self.testImageView];
        [_mywhiteBackgroundView addSubview:self.testTitleLabel];
        [_mywhiteBackgroundView addSubview:self.testExamSatusLabel];
        [_mywhiteBackgroundView addSubview:self.mytimeLabel];
        
        
        [self.testImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _mywhiteBackgroundView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _mywhiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 500 / CP_GLOBALSCALE ) );
            make.right.equalTo( _mywhiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE);
        }];
        
        [self.testTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.testImageView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.testImageView.mas_left );
            make.height.equalTo( @( 42 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.testImageView.mas_right );
        }];
        
        [self.testExamSatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.testImageView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.height.equalTo( @( 42 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.testImageView.mas_right );
        }];
        
        [self.mytimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.testTitleLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.testTitleLabel.mas_left );
            make.bottom.equalTo( _mywhiteBackgroundView.mas_bottom ).offset( -60 / CP_GLOBALSCALE );
        }];
    }
    return _mywhiteBackgroundView;
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

- (UILabel *)testExamSatusLabel
{
    if ( !_testExamSatusLabel )
    {
        _testExamSatusLabel = [[UILabel alloc] init];
        [_testExamSatusLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_testExamSatusLabel setTextColor:[UIColor colorWithHexString:@"ff5252"]];
    }
    return _testExamSatusLabel;
}

@end
