//
//  CPSearchHistoryFooterView.m
//  cepin
//
//  Created by kun on 16/1/9.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchHistoryFooterView.h"
#import "CPCommon.h"
@interface CPSearchHistoryFooterView ()

@end

@implementation CPSearchHistoryFooterView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [self addSubview:self.clearSearchHistoryButton];
        [self.clearSearchHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( @( 40 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
    }
    return self;
}

#pragma mark - getter methods
- (UIButton *)clearSearchHistoryButton
{
    if ( !_clearSearchHistoryButton )
    {
        _clearSearchHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearSearchHistoryButton setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_clearSearchHistoryButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_clearSearchHistoryButton.layer setBorderWidth:2.0 / CP_GLOBALSCALE];
        [_clearSearchHistoryButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [_clearSearchHistoryButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE ]];
        [_clearSearchHistoryButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_clearSearchHistoryButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    }
    return _clearSearchHistoryButton;
}
@end
