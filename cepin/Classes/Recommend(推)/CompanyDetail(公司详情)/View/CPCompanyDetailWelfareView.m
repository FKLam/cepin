//
//  CPCompanyDetailWelfareView.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyDetailWelfareView.h"
#import "CPCommon.h"
@interface CPCompanyDetailWelfareView ()

@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *requireLabel;
@property (nonatomic, strong) NSArray *welfareArray;
@property (nonatomic, strong) NSMutableArray *welfareButtonM;
@end

@implementation CPCompanyDetailWelfareView
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
- (void)configWithArray:(NSArray *)welfareArray
{
    _welfareArray = welfareArray;
    for ( UIButton *subBtn in self.welfareButtonM )
    {
        [subBtn removeFromSuperview];
    }
    [self.welfareButtonM removeAllObjects];
    for (NSString *subStr in _welfareArray )
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"707070"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:32 / CP_GLOBALSCALE]];
        [btn.layer setCornerRadius:6 / CP_GLOBALSCALE];
        [btn.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
        btn.hidden = YES;
        [btn setEnabled:NO];
        [btn setTitle:subStr forState:UIControlStateNormal];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [self addSubview:btn];
        [self.welfareButtonM addObject:btn];
    }
    [self setNeedsDisplay];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat buttonX = 40 / CP_GLOBALSCALE;
    CGFloat buttonY = CGRectGetMaxY(self.requireLabel.frame) + 60 / CP_GLOBALSCALE;
    CGFloat buttonH = ( 15 + 15 + 32 ) / CP_GLOBALSCALE;
    CGFloat buttonW = 0;
    NSString *buttonTitle = nil;
    UIButton *btn = nil;
    CGFloat maxX = kScreenWidth - 80 / CP_GLOBALSCALE;
    NSUInteger buttonIndex = 0;
    NSUInteger stop = 0;
    for ( NSUInteger index = 0; index < [_welfareArray count]; index++ )
    {
        if ( 2 == stop )
            break;
        buttonTitle = _welfareArray[index];
        buttonW = 15 / CP_GLOBALSCALE * 2 + 32 / CP_GLOBALSCALE * buttonTitle.length;
//        if ( maxX < buttonW + buttonX )
//            continue;
        btn = self.welfareButtonM[buttonIndex];
        [btn setTitle:buttonTitle forState:UIControlStateNormal];
        [btn setHidden:NO];
//        buttonX += buttonW + 20 / 3.0;
        if ( buttonX+buttonW + 20 / CP_GLOBALSCALE> maxX )
        {
            stop++;
            if (stop==2) {
                return;
            }
            buttonX = 40 / CP_GLOBALSCALE;
            buttonY += buttonH + 20 / CP_GLOBALSCALE;
            btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            buttonX += buttonW + 20 / CP_GLOBALSCALE;
        }else{
             btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            buttonX += buttonW + 20 / CP_GLOBALSCALE;
        }
        buttonIndex++;
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
        [_requireLabel setText:@"企业福利"];
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
- (NSMutableArray *)welfareButtonM
{
    if ( !_welfareButtonM )
    {
        _welfareButtonM = [NSMutableArray array];
    }
    return _welfareButtonM;
}
@end
