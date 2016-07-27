//
//  CPSearchMatchCell.m
//  cepin
//
//  Created by kun on 16/1/9.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchMatchCell.h"
#import "CPCommon.h"
@interface CPSearchMatchCell ()
@property (nonatomic, strong) UIImageView *historyImageView;
@property (nonatomic, strong) UILabel *historyTitleLabel;
@property (nonatomic, strong) UIView *historySeparatorLine;
@end

@implementation CPSearchMatchCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.historyImageView];
        
        [self.contentView addSubview:self.historyTitleLabel];
        
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
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE);
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}

+ (instancetype)searchMatchCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"searchMatchCell";
    CPSearchMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPSearchMatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)configSearchMatchCell:(NSString *)searchMatchTitle matchString:(NSString *)matchStrin hideSeparator:(BOOL)hideSeparator
{
    if ( !searchMatchTitle || !matchStrin )
        return;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:searchMatchTitle attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]}];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:matchStrin options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *resultArray = [regex matchesInString:searchMatchTitle options:0 range:NSMakeRange(0, [searchMatchTitle length])];
    for ( NSTextCheckingResult *result in resultArray )
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:result.range];
    }
    self.historyTitleLabel.attributedText = attString;
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
