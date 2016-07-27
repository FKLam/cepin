//
//  CPSearchFilterCell.m
//  cepin
//
//  Created by ceping on 16/1/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchCityFilterCell.h"

@interface CPSearchCityFilterCell ()


@property (nonatomic, strong) UIView *filterSeparatorLine;
@property (nonatomic, strong) UIImageView *selectedImageView;
@end

@implementation CPSearchCityFilterCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.cityFilterTitleLabel];
        
        [self.contentView addSubview:self.selectedImageView];
        
        [self.contentView addSubview:self.filterSeparatorLine];
        
        
        [self.cityFilterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.left.equalTo( self.mas_left ).offset( 100 / 3.0 );
            make.height.equalTo( @( self.cityFilterTitleLabel.font.pointSize ) );
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

-(void)resetLineWithShowFull:(BOOL)show{
    if (show) {
        [self.filterSeparatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 0 );
            make.right.equalTo( self.mas_right ).offset( 0);
            make.height.equalTo( @( 2 / 3.0 ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }else{
        [self.filterSeparatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / 3.0 );
            make.right.equalTo( self.mas_right ).offset( -40 / 3.0);
            make.height.equalTo( @( 2 / 3.0 ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
}

+ (instancetype)searchCityFilterCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"searchCityFilterCell";
    CPSearchCityFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPSearchCityFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)configWithSearchCityFilterTitle:(NSString *)searchFilterTitle hideSelectedImage:(BOOL)hideSelectedImage
{
    [self.cityFilterTitleLabel setText:searchFilterTitle];
    [self.selectedImageView setHidden:hideSelectedImage];
}

#pragma mark - getters methods
- (UILabel *)cityFilterTitleLabel
{
    if ( !_cityFilterTitleLabel )
    {
        _cityFilterTitleLabel = [[UILabel alloc] init];
        [_cityFilterTitleLabel setFont:[UIFont systemFontOfSize:42.0 / 3.0]];
        [_cityFilterTitleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _cityFilterTitleLabel;
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
