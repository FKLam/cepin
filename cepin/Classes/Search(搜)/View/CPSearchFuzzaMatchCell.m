//
//  CPSearchFuzzaMatchCell.m
//  cepin
//
//  Created by dujincai on 16/3/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchFuzzaMatchCell.h"

@interface CPSearchFuzzaMatchCell ()

@property (nonatomic, strong) UIImageView *historyImageView;
@property (nonatomic, strong) UILabel *historyTitleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *historySeparatorLine;

@end

@implementation CPSearchFuzzaMatchCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.historyImageView];
        
        [self.contentView addSubview:self.historyTitleLabel];
        
        [self.contentView addSubview:self.countLabel];
        
        [self.contentView addSubview:self.historySeparatorLine];
        
        [self.historyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.left.equalTo( self.mas_left ).offset( 60 / 3.0 );
            make.width.equalTo( @( 48 / 3.0 ) );
            make.height.equalTo( @( 48 / 3.0 ));
        }];
        
        [self.historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.left.equalTo( self.historyImageView.mas_right ).offset( 35 / 3.0 );
            make.height.equalTo( @( self.historyTitleLabel.font.pointSize ) );
            make.right.equalTo( self.countLabel.mas_left );
        }];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.right.equalTo( self.mas_right ).offset( -40 / 3.0 );
            make.width.equalTo( @( 130 / 3.0 ) );
            make.height.equalTo( @( 48 / 3.0 ) );
        }];
        
        [self.historySeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / 3.0 );
            make.right.equalTo( self.mas_right ).offset( -40 / 3.0);
            make.height.equalTo( @( 2 / 3.0 ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}

+ (instancetype)searchHistoryCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"searchFuzzaMatchCell";
    CPSearchFuzzaMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[CPSearchFuzzaMatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)configWithKeywordModel:(SearchMatch *)model matchText:(NSString *)matchText hideSeparator:(BOOL)hideSeparator
{
    if ( !model )
        return;
    if (matchText) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:model.Keyword attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:42 / 3.0]}];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:matchText options:NSRegularExpressionCaseInsensitive error:NULL];
        NSArray *resultArray = [regex matchesInString:model.Keyword options:0 range:NSMakeRange(0, [model.Keyword length])];
        for ( NSTextCheckingResult *result in resultArray )
        {
            [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:result.range];
        }
        
        self.historyTitleLabel.attributedText = attString;

    }else{
        self.historyTitleLabel.text =model.Keyword;
    }
        [self.historySeparatorLine setHidden:hideSeparator];
    self.countLabel.text = [NSString stringWithFormat:@"%@条",model.PositionCount];
    [self layoutIfNeeded];
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
        [_historyTitleLabel setFont:[UIFont systemFontOfSize:36.0 / 3.0]];
        [_historyTitleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _historyTitleLabel;
}
- (UILabel *)countLabel
{
    if ( !_countLabel )
    {
        _countLabel = [[UILabel alloc] init];
        [_countLabel setFont:[UIFont systemFontOfSize:36.0 / 3.0]];
        [_countLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [self.countLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _countLabel;
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
