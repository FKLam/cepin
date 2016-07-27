//
//  CPSearchFilterCell.m
//  cepin
//
//  Created by ceping on 16/1/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchFilterCell.h"

@interface CPSearchFilterCell ()


@property (nonatomic, strong) UIView *filterSeparatorLine;
@property (nonatomic, strong) UIImageView *selectedImageView;
@end

@implementation CPSearchFilterCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.filterTitleLabel];
        
        [self.contentView addSubview:self.selectedImageView];
        
        [self.contentView addSubview:self.filterSeparatorLine];
        
        
        [self.filterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.left.equalTo( self.mas_left ).offset( 60 / 3.0 );
            make.height.equalTo( @( self.filterTitleLabel.font.pointSize ) );
            make.right.equalTo( self.selectedImageView.mas_left );
        }];
        
        [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.right.equalTo( self.mas_right ).offset( -60 / 3.0 );
            make.width.equalTo( @( 70 / 3.0 ) );
            make.height.equalTo( @( 70 / 3.0 ) );
        }];
        
        [self.filterSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / 3.0 );
            make.right.equalTo( self.mas_right ).offset( -40 / 3.0);
            make.height.equalTo( @( 2 / 3.0 ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}

+ (instancetype)searchFilterCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"searchFilterCell";
    CPSearchFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPSearchFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)configWithSearchFilterTitle:(NSString *)searchFilterTitle hideSelectedImage:(BOOL)hideSelectedImage
{
    [self.filterTitleLabel setText:searchFilterTitle];
    
    if ( hideSelectedImage )
    {
        [self.filterTitleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    else
    {
        [self.filterTitleLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
    }
    
    [self.selectedImageView setHidden:hideSelectedImage];
}

#pragma mark - getters methods
- (UILabel *)filterTitleLabel
{
    if ( !_filterTitleLabel )
    {
        _filterTitleLabel = [[UILabel alloc] init];
        [_filterTitleLabel setFont:[UIFont systemFontOfSize:42.0 / 3.0]];
        [_filterTitleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _filterTitleLabel;
}
- (UIView *)filterSeparatorLine
{
    if ( !_filterSeparatorLine )
    {
        _filterSeparatorLine = [[UIView alloc] init];
        [_filterSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _filterSeparatorLine;
}
- (UIImageView *)selectedImageView
{
    if ( !_selectedImageView )
    {
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.image = [UIImage imageNamed:@"ic_tick"];
        _selectedImageView.hidden = YES;
    }
    return _selectedImageView;
}
@end
