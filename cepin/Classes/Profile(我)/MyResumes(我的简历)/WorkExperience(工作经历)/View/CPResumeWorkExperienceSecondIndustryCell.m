//
//  CPResumeWorkExperienceSecondIndustryCell.m
//  cepin
//
//  Created by ceping on 16/2/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeWorkExperienceSecondIndustryCell.h"
#import "CPCommon.h"
@interface CPResumeWorkExperienceSecondIndustryCell ()
@property(nonatomic,retain)UILabel *labelTitle;
@property (nonatomic, assign) BOOL isSeleceted;
@property (nonatomic, strong) UIImageView *selectedImageView;
@end
@implementation CPResumeWorkExperienceSecondIndustryCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(80 / CP_GLOBALSCALE, 0, self.viewWidth - ( 80 + 70 + 35 ) / CP_GLOBALSCALE, 144 / CP_GLOBALSCALE)];
        self.labelTitle.textColor = [UIColor colorWithHexString:@"404040"];
        self.labelTitle.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
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
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.contentView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top ).offset( ( 144 - 2 ) / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return self;
}
+ (instancetype)workExperienceCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"CPResumeWorkExperienceSecondIndustryCell";
    CPResumeWorkExperienceSecondIndustryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPResumeWorkExperienceSecondIndustryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configWithTitle:(NSString *)titleStr isSelected:(BOOL)isSelected
{
    _isSeleceted = isSelected;
    [self.labelTitle setText:titleStr];
    [self setSelected:_isSeleceted];
    if ( _isSeleceted )
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self.selectedImageView setHidden:NO];
    }
    else
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.selectedImageView setHidden:YES];
    }
}
@end
