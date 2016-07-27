//
//  CPResumeEducationSearchMatchCell.m
//  cepin
//
//  Created by ceping on 16/3/7.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEducationSearchMatchCell.h"
@interface CPResumeEducationSearchMatchCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorLine;
@end
@implementation CPResumeEducationSearchMatchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.separatorLine];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / 3.0 );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right ).offset( -40 / 3.0 );
        }];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / 3.0 );
            make.bottom.equalTo( self.mas_bottom );
            make.height.equalTo( @( 2 / 3.0 ) );
            make.right.equalTo( self.mas_right ).offset( -40 / 3.0 );
        }];
    }
    return self;
}
+ (instancetype)educationSearchMatchCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentify = @"CPResumeEducationSearchMatchCell";
    CPResumeEducationSearchMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentify];
    if ( !cell )
    {
        cell = [[CPResumeEducationSearchMatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentify];
    }
    return cell;
}
- (void)configWithSchool:(School *)school isHideSeparatorLine:(BOOL)isHideSeparatorLine
{
    [self.titleLabel setText:school.Name];
    [self.separatorLine setHidden:isHideSeparatorLine];
}
- (void)configWithMajor:(BaseCode *)major isHideSeparatorLine:(BOOL)isHideSeparatorLine
{
    [self.titleLabel setText:major.CodeName];
    [self.separatorLine setHidden:isHideSeparatorLine];
}
#pragma mark - getter methods
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / 3.0]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _titleLabel;
}
- (UIView *)separatorLine
{
    if ( !_separatorLine )
    {
        _separatorLine = [[UIView alloc] init];
        [_separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _separatorLine;
}
@end