//
//  CPHomeBindTestView.m
//  cepin
//
//  Created by ceping on 16/1/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomeBindTestView.h"
#import "CPCommon.h"
@interface CPHomeBindTestView ()
@property (nonatomic, strong) UIView *bindEmailBackgroundView;
@property (nonatomic, strong) UIView *testBackgroundView;
@property (nonatomic, strong) UIButton *clickedBindButton;
@property (nonatomic, strong) UIButton *clickedTestButton;
@property (nonatomic, strong) UIView *separatorLine;
@end
@implementation CPHomeBindTestView
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [self addSubview:self.bindEmailBackgroundView];
        [self.bindEmailBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
            make.width.equalTo( @( self.viewWidth / 2.0 ) );
        }];
        [self addSubview:self.testBackgroundView];
        [self.testBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.right.equalTo( self.mas_right );
            make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
            make.width.equalTo( @( self.viewWidth / 2.0 ) );
        }];
        // 分隔线
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        self.separatorLine = separatorLine;
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.mas_right );
            make.top.equalTo( _bindEmailBackgroundView.mas_bottom );
        }];
    }
    return self;
}
- (void)resetFrameWithUserData:(NSString *)IsHasEmailVerify examData:(NSDictionary *)examData
{
    NSString *finishExam = nil;
    if ( ![[examData objectForKey:@"IsFinshed"] isKindOfClass:[NSNull class]] )
    {
        finishExam = [examData objectForKey:@"IsFinshed"];
    }
    NSString *hasEmailVerify = IsHasEmailVerify;
    if ( !finishExam && !hasEmailVerify )
    {
        [self.bindEmailBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
            make.width.equalTo( @( self.viewWidth / 2.0 ) );
        }];
        [self.testBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.right.equalTo( self.mas_right );
            make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
            make.width.equalTo( @( self.viewWidth / 2.0 ) );
        }];
        [self.bindEmailBackgroundView setHidden:NO];
        [self.testBackgroundView setHidden:NO];
    }
    else if ( hasEmailVerify && !finishExam )
    {
        if ( [hasEmailVerify length] == 0 )
        {
            [self.bindEmailBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.mas_top );
                make.left.equalTo( self.mas_left );
                make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                make.width.equalTo( @( self.viewWidth / 2.0 ) );
            }];
            [self.testBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.mas_top );
                make.right.equalTo( self.mas_right );
                make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                make.width.equalTo( @( self.viewWidth / 2.0 ) );
            }];
            [self.testBackgroundView setHidden:NO];
            [self.bindEmailBackgroundView setHidden:NO];
        }
        else if ( [hasEmailVerify length] > 0 )
        {
            [self.bindEmailBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.mas_top );
                make.left.equalTo( self.mas_left );
                make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                make.width.equalTo( @( self.viewWidth / 2.0 ) );
            }];
            [self.testBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.mas_top );
                make.right.equalTo( self.mas_right );
                make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                make.width.equalTo( @( self.viewWidth ) );
            }];
            [self.testBackgroundView setHidden:NO];
            [self.bindEmailBackgroundView setHidden:YES];
        }
    }
    else if ( !hasEmailVerify && finishExam )
    {
        if ( finishExam.intValue == 0 )
        {
            [self.bindEmailBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.mas_top );
                make.left.equalTo( self.mas_left );
                make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                make.width.equalTo( @( self.viewWidth / 2.0 ) );
            }];
            [self.bindEmailBackgroundView setHidden:NO];
            [self.testBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.mas_top );
                make.right.equalTo( self.mas_right );
                make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                make.width.equalTo( @( self.viewWidth / 2.0 ) );
            }];
            [self.testBackgroundView setHidden:NO];
        }
        else if ( finishExam.intValue == 1 )
        {
            [self.testBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.mas_top );
                make.right.equalTo( self.mas_right );
                make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                make.width.equalTo( @( self.viewWidth ) );
            }];
            [self.bindEmailBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.mas_top );
                make.left.equalTo( self.mas_left );
                make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                make.width.equalTo( @( self.viewWidth ) );
            }];
            [self.bindEmailBackgroundView setHidden:NO];
            [self.testBackgroundView setHidden:YES];
        }
    }
    else
    {
        if ( [IsHasEmailVerify length] > 0 )
        {
            if ( finishExam.intValue == 1 )
            {
                [self.testBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( self.mas_top );
                    make.right.equalTo( self.mas_right );
                    make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                    make.width.equalTo( @( self.viewWidth ) );
                }];
                [self.bindEmailBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( self.mas_top );
                    make.left.equalTo( self.mas_left );
                    make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                    make.width.equalTo( @( self.viewWidth ) );
                }];
                [self.bindEmailBackgroundView setHidden:YES];
                [self.testBackgroundView setHidden:YES];
            }
            else if ( finishExam.intValue == 0 )
            {
                [self.testBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( self.mas_top );
                    make.right.equalTo( self.mas_right );
                    make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                    make.width.equalTo( @( self.viewWidth ) );
                }];
                [self.bindEmailBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( self.mas_top );
                    make.left.equalTo( self.mas_left );
                    make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                    make.width.equalTo( @( self.viewWidth ) );
                }];
                [self.bindEmailBackgroundView setHidden:YES];
                [self.testBackgroundView setHidden:NO];
            }
        }
        else if ( [IsHasEmailVerify length] == 0 )
        {
            if ( finishExam.intValue == 1 )
            {
                [self.testBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( self.mas_top );
                    make.right.equalTo( self.mas_right );
                    make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                    make.width.equalTo( @( self.viewWidth ) );
                }];
                [self.bindEmailBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( self.mas_top );
                    make.left.equalTo( self.mas_left );
                    make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                    make.width.equalTo( @( self.viewWidth ) );
                }];
                [self.bindEmailBackgroundView setHidden:NO];
                [self.testBackgroundView setHidden:YES];
            }
            else if ( finishExam.intValue == 0 )
            {
                [self.testBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( self.mas_top );
                    make.right.equalTo( self.mas_right );
                    make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                    make.width.equalTo( @( self.viewWidth / 2.0 ) );
                }];
                [self.bindEmailBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( self.mas_top );
                    make.left.equalTo( self.mas_left );
                    make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
                    make.width.equalTo( @( self.viewWidth / 2.0 ) );
                }];
                [self.bindEmailBackgroundView setHidden:NO];
                [self.testBackgroundView setHidden:NO];
            }
        }
    }
}
#pragma mark - getter methods
- (UIView *)bindEmailBackgroundView
{
    if ( !_bindEmailBackgroundView )
    {
        _bindEmailBackgroundView = [[UIView alloc] init];
        [_bindEmailBackgroundView setBackgroundColor:[UIColor whiteColor]];
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailLabel setText:@"绑定邮箱增强帐号安全性"];
        [detailLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [detailLabel setFont:[UIFont systemFontOfSize:34 / CP_GLOBALSCALE ]];
        [_bindEmailBackgroundView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _bindEmailBackgroundView.mas_top ).offset( (self.viewHeight - 30 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE) / 2.0 - detailLabel.font.pointSize );
            make.left.equalTo( _bindEmailBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( detailLabel.font.pointSize ) );
        }];
        UILabel *bindNowLabel = [[UILabel alloc] init];
        [bindNowLabel setText:@"马上绑定"];
        [bindNowLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [bindNowLabel setFont:[UIFont systemFontOfSize:32 / CP_GLOBALSCALE ]];
        [_bindEmailBackgroundView addSubview:bindNowLabel];
        [bindNowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _bindEmailBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( bindNowLabel.font.pointSize ) );
            make.bottom.equalTo( _bindEmailBackgroundView.mas_bottom ).offset( -((self.viewHeight - 30 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE) / 2.0 - bindNowLabel.font.pointSize) );
        }];
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"ic_next"];
        [_bindEmailBackgroundView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _bindEmailBackgroundView.mas_centerY );
            make.right.equalTo( _bindEmailBackgroundView.mas_right ).offset( -20 / CP_GLOBALSCALE );
            make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 84 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_bindEmailBackgroundView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _bindEmailBackgroundView.mas_centerY );
            make.width.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 150 / CP_GLOBALSCALE ) );
            make.right.equalTo( _bindEmailBackgroundView.mas_right );
        }];
        [_bindEmailBackgroundView addSubview:self.clickedBindButton];
        [self.clickedBindButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _bindEmailBackgroundView.mas_top );
            make.left.equalTo( _bindEmailBackgroundView.mas_left );
            make.bottom.equalTo( _bindEmailBackgroundView.mas_bottom );
            make.right.equalTo( _bindEmailBackgroundView.mas_right );
        }];
    }
    return _bindEmailBackgroundView;
}
- (UIView *)testBackgroundView
{
    if ( !_testBackgroundView )
    {
        _testBackgroundView = [[UIView alloc] init];
        [_testBackgroundView setBackgroundColor:[UIColor whiteColor]];
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailLabel setText:@"测评一下，发现职业方向"];
        [detailLabel setTextColor:[UIColor colorWithHexString:@"6cbb56"]];
        [detailLabel setFont:[UIFont systemFontOfSize:34 / CP_GLOBALSCALE ]];
        [_testBackgroundView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _testBackgroundView.mas_top ).offset( (self.viewHeight - 30 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE) / 2.0 - detailLabel.font.pointSize );
            make.left.equalTo( _testBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( detailLabel.font.pointSize ) );
        }];
        UILabel *bindNowLabel = [[UILabel alloc] init];
        [bindNowLabel setText:@"马上测评"];
        [bindNowLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [bindNowLabel setFont:[UIFont systemFontOfSize:32 / CP_GLOBALSCALE ]];
        [_testBackgroundView addSubview:bindNowLabel];
        [bindNowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _testBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( bindNowLabel.font.pointSize ) );
            make.bottom.equalTo( _testBackgroundView.mas_bottom ).offset( -((self.viewHeight - 30 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE) / 2.0 - bindNowLabel.font.pointSize) );
        }];
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"ic_next"];
        [_testBackgroundView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _testBackgroundView.mas_centerY );
            make.right.equalTo( _testBackgroundView.mas_right ).offset( -20 / CP_GLOBALSCALE );
            make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 84 / CP_GLOBALSCALE ) );
        }];
        [_testBackgroundView addSubview:self.clickedTestButton];
        [self.clickedTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _testBackgroundView.mas_top );
            make.left.equalTo( _testBackgroundView.mas_left );
            make.bottom.equalTo( _testBackgroundView.mas_bottom );
            make.right.equalTo( _testBackgroundView.mas_right );
        }];
    }
    return _testBackgroundView;
}
- (UIButton *)clickedBindButton
{
    if ( !_clickedBindButton )
    {
        __weak typeof( self ) weakSelf = self;
        _clickedBindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickedBindButton setBackgroundColor:[UIColor clearColor]];
        [_clickedBindButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [weakSelf.homeBindTestViewDelegate respondsToSelector:@selector(homeBindTestView:isCanBind:)] )
            {
                [weakSelf.homeBindTestViewDelegate homeBindTestView:weakSelf isCanBind:YES];
            }
        }];
    }
    return _clickedBindButton;
}
- (UIButton *)clickedTestButton
{
    if ( !_clickedTestButton )
    {
        __weak typeof( self ) weakSelf = self;
        _clickedTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickedTestButton setBackgroundColor:[UIColor clearColor]];
        [_clickedTestButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [weakSelf.homeBindTestViewDelegate respondsToSelector:@selector(homeBindTestView:isCanTest:)] )
            {
                [weakSelf.homeBindTestViewDelegate homeBindTestView:weakSelf isCanTest:YES];
            }
        }];
    }
    return _clickedTestButton;
}
@end
