//
//  CPWExpectAddressSearchCell.m
//  cepin
//
//  Created by ceping on 16/3/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWExpectAddressSearchCell.h"
#import "CPCommon.h"
@interface CPWExpectAddressSearchCell ()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIView *historySeparatorLine;
@end
@implementation CPWExpectAddressSearchCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(80 / CP_GLOBALSCALE, 0, self.viewWidth / 2.0, 144 / CP_GLOBALSCALE)];
        self.labelTitle.textColor = [UIColor colorWithHexString:@"404040"];
        self.labelTitle.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        self.selectedImageView = [[UIImageView alloc] init];
        self.selectedImageView.backgroundColor = [UIColor clearColor];
        self.selectedImageView.image = [UIImage imageNamed:@"ic_tick"];
        [self.selectedImageView setHidden:YES];
        [self.contentView addSubview:self.selectedImageView];
        [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self.mas_right ).offset( -35 / CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top ).offset( (144 - 70) / 2.0 / CP_GLOBALSCALE );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.contentView addSubview:separatorLine];
        self.historySeparatorLine = separatorLine;
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top ).offset( ( 144 - 2 ) / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return self;
}
+ (instancetype)searchMatchCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"CPWExpectAddressSearchCell";
    CPWExpectAddressSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPWExpectAddressSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configSearchMatchCell:(NSString *)searchMatchTitle matchString:(NSString *)matchStrin hideSeparator:(BOOL)hideSeparator isSelected:(BOOL)isSelected
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
    self.labelTitle.attributedText = attString;
    [self.historySeparatorLine setHidden:hideSeparator];
    [self.selectedImageView setHidden:!isSelected];
}
@end
