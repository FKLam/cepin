//
//  CPDeliveryResumeCell.m
//  cepin
//
//  Created by ceping on 16/3/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPDeliveryResumeCell.h"
@interface CPDeliveryResumeCell ()
@property (nonatomic, strong) UILabel *resumeName;
@property (nonatomic, strong) UILabel *resumeState;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIImageView *selecetdImageView;
@property (nonatomic, strong) ResumeNameModel *resume;
@end
@implementation CPDeliveryResumeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.resumeName];
        [self.contentView addSubview:self.resumeState];
        [self.contentView addSubview:self.selecetdImageView];
        [self.selecetdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self.mas_right ).offset( -( 35 ) / 3.0 );
            make.height.equalTo( @( 70 / 3.0 ) );
            make.width.equalTo( @( 70 / 3.0 ) );
            make.centerY.equalTo( self.mas_centerY );
        }];
        [self.contentView addSubview:self.separatorLine];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom );
            make.height.equalTo( @( 2 / 3.0 ) );
            make.right.equalTo( self.mas_right );
        }];
    }
    return self;
}
+ (instancetype)deliveryRsumeCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"CPDeliveryResumeCell";
    CPDeliveryResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPDeliveryResumeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configDeliveryCellWithResume:(ResumeNameModel *)resume isSelected:(BOOL)isSelecetd
{
    self.resume = resume;
    [self.resumeName setText:self.resume.ResumeName];
    [self.selecetdImageView setHidden:!isSelecetd];
}
- (void)hideSeparatorIsHide:(BOOL)isHide
{
    [self.separatorLine setHidden:isHide];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 简历是否可投状态
    NSString *completeString = nil;
    if ( self.resume.IsCompleteResume.intValue == 1 )
    {
        [self.resumeName setTextColor:[UIColor colorWithHexString:@"404040"]];
        completeString = @"(可投)";
        [self.resumeState setTextColor:[UIColor colorWithHexString:@"6cbb58"]];
    }
    else
    {
        [self.resumeName setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        completeString = @"(不可投)";
        [self.resumeState setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    [self.resumeState setText:completeString];
    CGFloat maxW = self.viewWidth - 70 / 3.0;
    CGFloat stateW = [completeString length] * 36 / 3.0;
//    CGFloat stateX = self.viewWidth - 70 / 3.0 - stateW;
    CGFloat stateY = ( self.viewHeight - 48 / 3.0 ) / 2.0 + ( 48 - 36 ) / 3.0;
    CGFloat stateH = 36 / 3.0;
    CGSize nameSize = [self.resume.ResumeName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:48 / 3.0]} context:nil].size;
    CGFloat nameW = nameSize.width;
    if ( nameW >= maxW )
        nameW = maxW - stateW;
    CGFloat nameX = 0;
    CGFloat nameY = 0;
    CGFloat nameH = self.viewHeight;
    [self.resumeName setFrame:CGRectMake(nameX, nameY, nameW, nameH)];
    [self.resumeState setFrame:CGRectMake(CGRectGetMaxX(self.resumeName.frame), stateY, stateW, stateH)];
}
#pragma mark - getter methods
- (UILabel *)resumeName
{
    if ( !_resumeName )
    {
        _resumeName = [[UILabel alloc] init];
        [_resumeName setFont:[UIFont systemFontOfSize:48 / 3.0]];
    }
    return _resumeName;
}
- (UILabel *)resumeState
{
    if ( !_resumeState )
    {
        _resumeState = [[UILabel alloc] init];
        [_resumeState setFont:[UIFont systemFontOfSize:36 / 3.0]];
    }
    return _resumeState;
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
- (UIImageView *)selecetdImageView
{
    if ( !_selecetdImageView )
    {
        _selecetdImageView = [[UIImageView alloc] init];
        [_selecetdImageView setImage:[UIImage imageNamed:@"ic_tick"]];
        [_selecetdImageView setHidden:NO];
    }
    return _selecetdImageView;
}
@end