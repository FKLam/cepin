//
//  CPHomeRecommendCell.m
//  cepin
//
//  Created by ceping on 16/1/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomeRecommendCell.h"
#import "CPCommon.h"
@interface CPHomeRecommendCell ()
@property (nonatomic, strong) UIView *whiteBackground;
@property (nonatomic, strong) NSArray *businessLogoArray;
@property (nonatomic, strong) NSArray *businessNameArray;
@property (nonatomic, strong) NSArray *imageDataArray;
@property (nonatomic, strong) NSMutableArray *imageButtonArrayM;
@end
@implementation CPHomeRecommendCell
#define CPBUSINESS_COUNT 6
#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        CGFloat W = (kScreenWidth - 50 * 2 / CP_GLOBALSCALE - 40 * 2 / CP_GLOBALSCALE) / 3.0;
        CGFloat H = W;
        CGFloat margin = 50 / CP_GLOBALSCALE;
        CGFloat X = 40 / CP_GLOBALSCALE;
        CGFloat imageY = 50 / CP_GLOBALSCALE;
        for (NSUInteger index = 0; index < CPBUSINESS_COUNT; index++) {
            UIImageView *logoImageView = self.businessLogoArray[index];
            UILabel *nameLabel = self.businessNameArray[index];
            [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.whiteBackground.mas_top ).offset( imageY );
                make.left.equalTo( self.whiteBackground.mas_left ).offset( X );
                make.width.equalTo( @( W ) );
                make.height.equalTo( @( H ) );
            }];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( logoImageView.mas_bottom ).offset( 24 / CP_GLOBALSCALE );
                make.left.equalTo( logoImageView.mas_left );
                make.height.equalTo( @( nameLabel.font.pointSize ) );
                make.width.equalTo( logoImageView.mas_width );
            }];
            if ( 2 == index )
            {
                X = 40 / CP_GLOBALSCALE;
                imageY += W + 24 / CP_GLOBALSCALE + 36 / CP_GLOBALSCALE + 50 / CP_GLOBALSCALE;
            }
            else
            {
                X += W + margin;
            }
        }
    }
    return self;
}
+ (instancetype)homeRecommendCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"homeRecommendCell";
    CPHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPHomeRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configWithDataArray:(NSArray *)DataArray next:(NSUInteger)next
{
    if ( !DataArray || 0 == [DataArray count] )
        return;
    if ( 0 < [_imageDataArray count] )
    {
        for (UILabel *label in self.businessNameArray )
        {
            [label setText:@""];
            [label setHidden:YES];
        }
        for (UIImageView *imageView in self.businessLogoArray )
        {
            [imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"null_index_logo"]];
            [imageView setHidden:YES];
        }
    }
    _imageDataArray = [DataArray copy];
    NSUInteger count = [_imageDataArray count];
    NSUInteger beginIndex = CPBUSINESS_COUNT * next % count;
    NSInteger buttonIndex = 0;
    for (NSInteger index = beginIndex; index < count; index++)
    {
        NSDictionary *dict = _imageDataArray[index];
        NSString *companyName = @"";
        if ( ![[dict valueForKey:@"Shortname"] isKindOfClass:[NSNull class]] )
        {
            companyName = [dict valueForKey:@"Shortname"];
            if ( !companyName || 0 == [companyName length] )
            {
                if ( ![[dict valueForKey:@"CompanyShowName"] isKindOfClass:[NSNull class]] )
                    companyName = [dict valueForKey:@"CompanyShowName"];
            }
        }
        else if ( ![[dict valueForKey:@"CompanyShowName"] isKindOfClass:[NSNull class]] )
            companyName = [dict valueForKey:@"CompanyShowName"];
        UILabel *label = self.businessNameArray[buttonIndex];
        [label setText:companyName];
        [label setHidden:NO];
        UIImageView *logoImageView = self.businessLogoArray[buttonIndex];
        [logoImageView setHidden:NO];
        UIButton *imageButton = self.imageButtonArrayM[buttonIndex];
        [imageButton setTag:index];
        NSString *urlStr = @"";
        if ( ![[dict valueForKey:@"LogoUrl"] isKindOfClass:[NSNull class]] )
            urlStr = [dict valueForKey:@"LogoUrl"];
        NSURL *url = [NSURL URLWithString:urlStr];
        [logoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"null_index_logo"]];
        buttonIndex++;
        if ( 6 == buttonIndex )
        {
            break;
        }
        else if ( index == count - 1 )
        {
            index = -1;
        }
    }
}
#pragma mark - getter methods
- (UIView *)whiteBackground
{
    if ( !_whiteBackground )
    {
        _whiteBackground = [[UIView alloc] init];
        [_whiteBackground setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.contentView addSubview:_whiteBackground];
        [_whiteBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right );
        }];
    }
    return _whiteBackground;
}
- (NSArray *)businessLogoArray
{
    if ( !_businessLogoArray )
    {
        NSMutableArray *logoM = [NSMutableArray array];
        for ( NSUInteger index = 0; index < CPBUSINESS_COUNT; index++ )
        {
            UIImageView *logoImageView = [[UIImageView alloc] init];
            [logoImageView.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
            [logoImageView.layer setBorderWidth:2 / CP_GLOBALSCALE];
            [logoImageView setUserInteractionEnabled:YES];
            [logoImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"null_index_logo"]];
            [self.whiteBackground addSubview:logoImageView];
            [logoM addObject:logoImageView];
        }
        _businessLogoArray = [logoM copy];
    }
    return _businessLogoArray;
}
- (NSArray *)businessNameArray
{
    if ( !_businessNameArray )
    {
        NSMutableArray *nameM = [NSMutableArray array];
        for ( NSUInteger index = 0; index < CPBUSINESS_COUNT; index++ )
        {
            UILabel *nameLabel = [[UILabel alloc] init];
            [nameLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE ]];
            [nameLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
            [nameLabel setTextAlignment:NSTextAlignmentCenter];
            [self.whiteBackground addSubview:nameLabel];
            [nameM addObject:nameLabel];
        }
        _businessNameArray = [nameM copy];
    }
    return _businessNameArray;
}
- (NSArray *)imageDataArray
{
    if ( !_imageDataArray )
    {
        _imageDataArray = [NSArray array];
    }
    return _imageDataArray;
}
- (NSMutableArray *)imageButtonArrayM
{
    if ( !_imageButtonArrayM )
    {
        __weak typeof( self ) weakSelf = self;
        _imageButtonArrayM = [NSMutableArray array];
        for ( UIImageView *imageViwe in self.businessLogoArray )
        {
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageButton setBackgroundColor:[UIColor clearColor]];
            [imageViwe addSubview:imageButton];
            [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( imageViwe.mas_top );
                make.left.equalTo( imageViwe.mas_left );
                make.bottom.equalTo( imageViwe.mas_bottom );
                make.right.equalTo( imageViwe.mas_right );
            }];
            [imageButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
                if ( [weakSelf.homeRecommendCellDelegate respondsToSelector:@selector(homeRecommendCell:clickedButton:)] )
                {
                    [self.homeRecommendCellDelegate homeRecommendCell:weakSelf clickedButton:sender];
                }
            }];
            [_imageButtonArrayM addObject:imageButton];
        }
    }
    return _imageButtonArrayM;
}
@end
