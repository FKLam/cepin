//
//  CPResumeInforAddressMatchCityCell.m
//  cepin
//
//  Created by ceping on 16/3/6.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeInforAddressMatchCityCell.h"
#import "CPCommon.h"
@interface CPResumeInforAddressMatchCityCell ()
@property (nonatomic, strong) UIImageView *historyImageView;
@property (nonatomic, strong) UILabel *historyTitleLabel;
@property (nonatomic, strong) UIView *historySeparatorLine;
@property (nonatomic, strong) UIImageView *selectedImageView;
@end
@implementation CPResumeInforAddressMatchCityCell
#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.historyImageView];
        [self.contentView addSubview:self.historyTitleLabel];
        self.selectedImageView = [[UIImageView alloc] init];
        self.selectedImageView.backgroundColor = [UIColor clearColor];
        self.selectedImageView.image = [UIImage imageNamed:@"ic_tick"];
        [self.contentView addSubview:self.selectedImageView];
        [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self.mas_right ).offset( -35 / CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top ).offset( (144 - 70) / 2.0 / CP_GLOBALSCALE );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        [self.contentView addSubview:self.historySeparatorLine];
        [self.historyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.left.equalTo( self.mas_left ).offset( 60 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ));
        }];
        [self.historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.left.equalTo( self.historyImageView.mas_right ).offset( 35 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.historyTitleLabel.font.pointSize ) );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.historySeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( 0 );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}
+ (instancetype)searchMatchCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"searchMatchCell";
    CPResumeInforAddressMatchCityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPResumeInforAddressMatchCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configSearchMatchCell:(Region *)region matchString:(NSString *)matchString hideSeparator:(BOOL)hideSeparator isSelected:(BOOL)isSelected
{
    if ( !region || !matchString )
        return;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:region.RegionName attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]}];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:matchString options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *resultArray = [regex matchesInString:region.RegionName options:0 range:NSMakeRange(0, [region.RegionName length])];
    for ( NSTextCheckingResult *result in resultArray )
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:result.range];
    }
    self.historyTitleLabel.attributedText = attString;
    if ( hideSeparator )
    {
        [self.historySeparatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 0 );
            make.right.equalTo( self.mas_right ).offset( 0 );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    else
    {
        [self.historySeparatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( 0 );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    [self.selectedImageView setHidden:!isSelected];
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
    }
    return _historyTitleLabel;
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
@end
