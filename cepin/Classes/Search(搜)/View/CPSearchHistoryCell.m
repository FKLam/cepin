//
//  CPSearchHistoryCell.m
//  cepin
//
//  Created by kun on 16/1/8.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchHistoryCell.h"
#import "CPCommon.h"
@interface CPSearchHistoryCell ()

@property (nonatomic, strong) UIImageView *historyImageView;
@property (nonatomic, strong) UILabel *historyTitleLabel;

@property (nonatomic, strong) UIView *historySeparatorLine;

@end

@implementation CPSearchHistoryCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.historyImageView];
        
        [self.contentView addSubview:self.historyTitleLabel];
        
        [self.contentView addSubview:self.historyDeleteButton];
        
        [self.contentView addSubview:self.historySeparatorLine];
        
        [self.contentView addSubview:self.deleteView];
        
        [self.historyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.left.equalTo( self.mas_left ).offset( 60 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ));
        }];
        
        [self.historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.left.equalTo( self.historyImageView.mas_right ).offset( 35 / CP_GLOBALSCALE );
            make.right.equalTo( self.historyDeleteButton.mas_left );
        }];
        
        [self.historyDeleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.right.equalTo( self.mas_right ).offset( -60 / CP_GLOBALSCALE );
            make.width.equalTo( @( 54 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 54 / CP_GLOBALSCALE ) );
        }];
        
        [self.deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.right.equalTo( self.mas_right ).offset( -30 / CP_GLOBALSCALE );
            make.width.equalTo( @( 80 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 80 / CP_GLOBALSCALE ) );
        }];

        
        [self.historySeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE);
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}

+ (instancetype)searchHistoryCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"searchHistoryCell";
    CPSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[CPSearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (void)configWithKeywordModel:(KeywordModel *)model hideSeparator:(BOOL)hideSeparator
{
    if ( !model )
        return;
    
    [self.historyTitleLabel setText:model.keyword];
    [self.historySeparatorLine setHidden:hideSeparator];
}

#pragma mark - getters methods
- (UIImageView *)historyImageView
{
    if ( !_historyImageView )
    {
        _historyImageView = [[UIImageView alloc] init];
        _historyImageView.image = [UIImage imageNamed:@"search_ic_history"];
    }
    return _historyImageView;
}
- (UILabel *)historyTitleLabel
{
    if ( !_historyTitleLabel )
    {
        _historyTitleLabel = [[UILabel alloc] init];
        [_historyTitleLabel setFont:[UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE]];
        [_historyTitleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _historyTitleLabel;
}
- (UIButton *)historyDeleteButton
{
    if ( !_historyDeleteButton )
    {
        _historyDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_historyDeleteButton setImage:[UIImage imageNamed:@"search_ic_cancel"] forState:UIControlStateNormal];
//        [_historyDeleteButton setBackgroundImage:[UIImage imageNamed:@"search_ic_cancel"] forState:UIControlStateNormal];
    }
    return _historyDeleteButton;
}
- (UIView *)historySeparatorLine
{
    if ( !_historySeparatorLine )
    {
        _historySeparatorLine = [[UIView alloc] init];
        [_historySeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _historySeparatorLine;
}

- (UIButton *)deleteView
{
    if ( !_deleteView )
    {
        _deleteView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteView setBackgroundColor:[UIColor clearColor]];
    }
    return _deleteView;
}

@end
