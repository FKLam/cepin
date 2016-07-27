//
//  CPResumeAttachInformationView.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeAttachInformationView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPResumeAdditionalImageButton.h"
#import "CPResumeEditReformer.h"
#import "CPCommon.h"
@interface CPResumeAttachInformationView ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *guessLabel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *attachmentInforLabel;
@property (nonatomic, strong) NSMutableArray *attachmentImageArrayM;
@end
@implementation CPResumeAttachInformationView
#pragma mark - lift cycle
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.blackBackgroundView];
        [self.blackBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}
- (void)configWithResume:(ResumeNameModel *)resumeModel
{
    [self resetData];
    _resumeModel = resumeModel;
    if ( resumeModel.AdditionInfo && 0 < [resumeModel.AdditionInfo length] )
    {
        [self.addMoreButton setHidden:YES];
        [self.editResumeButton setHidden:NO];
        [self.attachmentInforLabel setHidden:NO];
    }
    else if(nil != resumeModel.ResumeAttachmentList && [resumeModel.ResumeAttachmentList count]>0){
        [self.addMoreButton setHidden:YES];
        [self.editResumeButton setHidden:NO];
        [self.attachmentInforLabel setHidden:NO];
    }
    else
    {
        [self.addMoreButton setHidden:NO];
        [self.editResumeButton setHidden:YES];
        [self.attachmentInforLabel setHidden:YES];
        return;
    }
    [self configAttachmentInforLabel:self.attachmentInforLabel content:_resumeModel.AdditionInfo];
    CGFloat marge = [CPResumeEditReformer resumeEditAttachmentInfoImageMarge:_resumeModel];
    NSMutableArray *attachmentArrayM = resumeModel.ResumeAttachmentList;
    CGFloat imageWidth = ( kScreenWidth - 40 / CP_GLOBALSCALE * 8 ) / 5.0;
    CGFloat imageHeight = imageWidth + ( 30 + 24 + 24 ) / CP_GLOBALSCALE;
    CGFloat x = 40 / CP_GLOBALSCALE;
    NSInteger tag = 0;
    CPResumeAdditionalImageButton *button = nil;
    for ( NSDictionary *dict in attachmentArrayM )
    {
        if ( 5 < tag )
            break;
        button = [self reuseAttachmentButtonWithTag:tag attachmentDict:dict];
        UIButton *clickedButtonReviewImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clickedButtonReviewImageButton setBackgroundColor:[UIColor clearColor]];
        [clickedButtonReviewImageButton addTarget:self action:@selector(clickedImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [clickedButtonReviewImageButton setTag:tag];
        [button addSubview:clickedButtonReviewImageButton];
        [clickedButtonReviewImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( button.mas_top );
            make.left.equalTo( button.mas_left );
            make.bottom.equalTo( button.mas_bottom );
            make.right.equalTo( button.mas_right );
        }];
        if(resumeModel.AdditionInfo && 0 < [resumeModel.AdditionInfo length]){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.attachmentInforLabel.mas_bottom ).offset( marge );
                make.left.equalTo( self.whiteBackgroundView.mas_left ).offset( x );
                make.width.equalTo( @( imageWidth ) );
                make.height.equalTo( @( imageHeight ) );
            }];
            tag++;
            x += 40 / 3.0 + imageWidth;
        }
        else
        {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.topView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
//                make.top.equalTo( self.attachmentInforLabel.mas_bottom ).offset( marge );
                make.left.equalTo( self.whiteBackgroundView.mas_left ).offset( x );
                make.width.equalTo( @( imageWidth ) );
                make.height.equalTo( @( imageHeight ) );
            }];
            tag++;
            x += 40 / CP_GLOBALSCALE + imageWidth;
        }
    }
}
- (void)clickedImageButton:(UIButton *)sender
{
    if ( [self.resumeAttachInformationViewDelegate respondsToSelector:@selector(resumeAttachInformationView:reviewImageButton:imageArray:isImage:originArray:)] )
    {
        NSMutableArray *attachmentArrayM = self.resumeModel.ResumeAttachmentList;
        NSMutableArray *tempArrayM = [NSMutableArray array];
        BOOL sendIsImage = YES;
        NSInteger tempTag = 0;
        for ( NSDictionary *dict in attachmentArrayM )
        {
            NSString *attachmentName = nil;
            if ( ![[dict valueForKey:@"FilePath"] isKindOfClass:[NSNull class]] )
            {
                attachmentName = [dict valueForKey:@"FilePath"];
            }
            if ( attachmentName ) // 过滤非图片文件的浏览
            {
                BOOL isImage = YES;
                if ( [attachmentName rangeOfString:@".docx"].location != NSNotFound || [attachmentName rangeOfString:@".doc"].location != NSNotFound )
                {
                    isImage = NO;
                }
                else if ( [attachmentName rangeOfString:@".pptx"].location != NSNotFound || [attachmentName rangeOfString:@".ppt"].location != NSNotFound )
                {
                    isImage = NO;
                }
                else if ( [attachmentName rangeOfString:@".xlsx"].location != NSNotFound || [attachmentName rangeOfString:@".xls"].location != NSNotFound )
                {
                    isImage = NO;
                }
                else if ( [attachmentName rangeOfString:@".pdf"].location != NSNotFound )
                {
                    isImage = NO;
                }
                if ( isImage )
                {
                    [tempArrayM addObject:dict];
                }
                if ( tempTag == sender.tag )
                {
                    sendIsImage = isImage;
                }
            }
            tempTag++;
        }
        [self.resumeAttachInformationViewDelegate resumeAttachInformationView:self reviewImageButton:sender imageArray:tempArrayM isImage:sendIsImage originArray:attachmentArrayM];
    }
}
- (void)resetData
{
    for ( id obj in self.attachmentImageArrayM )
    {
        [obj removeFromSuperview];
    }
    [self.attachmentImageArrayM removeAllObjects];
}
- (CPResumeAdditionalImageButton *)reuseAttachmentButtonWithTag:(NSInteger)tag attachmentDict:(NSDictionary *)attachmentDict
{
    for ( CPResumeAdditionalImageButton *button in self.attachmentImageArrayM )
    {
        if ( button.tag == tag )
        {
            return button;
        }
    }
    CPResumeAdditionalImageButton *button = [[CPResumeAdditionalImageButton alloc] initWithFrame:CGRectZero];
    [button setTag:tag];
    [button configWithAttachment:attachmentDict isChangeFrame:YES];
    [self.whiteBackgroundView addSubview:button];
    [self.attachmentImageArrayM addObject:button];
    return button;
}
- (void)configAttachmentInforLabel:(CPPositionDetailDescribeLabel *)label content:(NSString *)content
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    [label setAttributedText:attStr];
}
#pragma mark - getter methods
- (UIView *)blackBackgroundView
{
    if ( !_blackBackgroundView )
    {
        _blackBackgroundView = [[UIView alloc] init];
        [_blackBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.04]];
        [_blackBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_blackBackgroundView.layer setMasksToBounds:YES];
        
        [_blackBackgroundView addSubview:self.whiteBackgroundView];
        [self.whiteBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _blackBackgroundView.mas_top );
            make.left.equalTo( _blackBackgroundView.mas_left );
            make.bottom.equalTo( _blackBackgroundView.mas_bottom ).offset( -6 / CP_GLOBALSCALE );
            make.right.equalTo( _blackBackgroundView.mas_right );
        }];
    }
    return _blackBackgroundView;
}
- (UIView *)whiteBackgroundView
{
    if ( !_whiteBackgroundView )
    {
        _whiteBackgroundView = [[UIView alloc] init];
        [_whiteBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:1.0]];
        [_whiteBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_whiteBackgroundView.layer setMasksToBounds:YES];
        [_whiteBackgroundView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top );
            make.left.equalTo( _whiteBackgroundView.mas_left );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        [_whiteBackgroundView addSubview:self.attachmentInforLabel];
        [self.attachmentInforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [_whiteBackgroundView addSubview:self.addMoreButton];
        [self.addMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topView.mas_bottom );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
    }
    return _whiteBackgroundView;
}
- (UIView *)topView
{
    if ( !_topView )
    {
        _topView = [[UIView alloc] init];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [_topView addSubview:self.titleBlueLineImageView];
        [_topView addSubview:self.guessLabel];
        [_topView addSubview:self.editResumeButton];
        
        [self.titleBlueLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _topView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [self.guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.guessLabel.font.pointSize ) );
        }];
        [self.editResumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _topView.mas_right );
            make.top.equalTo( _topView.mas_top );
            make.width.equalTo( _topView.mas_height );
            make.height.equalTo( _topView.mas_height );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _topView.mas_bottom );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _topView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _topView;
}
- (UILabel *)guessLabel
{
    if ( !_guessLabel )
    {
        _guessLabel = [[UILabel alloc] init];
        [_guessLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_guessLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_guessLabel setText:@"附加信息"];
    }
    return _guessLabel;
}
- (CPResumeMoreButton *)addMoreButton
{
    if ( !_addMoreButton )
    {
        _addMoreButton = [CPResumeMoreButton buttonWithType:UIButtonTypeCustom];
        [_addMoreButton setBackgroundColor:[UIColor clearColor]];
        [_addMoreButton setTitle:@"添加附加信息" forState:UIControlStateNormal];
        [_addMoreButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_addMoreButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_addMoreButton setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [_addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeMoreButton *sender) {
            
        }];
    }
    return _addMoreButton;
}
- (UIImageView *)titleBlueLineImageView
{
    if( !_titleBlueLineImageView )
    {
        _titleBlueLineImageView = [[UIImageView alloc] init];
        _titleBlueLineImageView.image = [UIImage imageNamed:@"title_highlight"];
    }
    return _titleBlueLineImageView;
}
- (CPResumeInformationButton *)editResumeButton
{
    if ( !_editResumeButton )
    {
        _editResumeButton = [[CPResumeInformationButton alloc] init];
        [_editResumeButton setBackgroundColor:[UIColor clearColor]];
        [_editResumeButton setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
    }
    return _editResumeButton;
}
- (CPPositionDetailDescribeLabel *)attachmentInforLabel
{
    if ( !_attachmentInforLabel )
    {
        _attachmentInforLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_attachmentInforLabel setVerticalAlignment:VerticalAlignmentTop];
        [_attachmentInforLabel setNumberOfLines:2];
    }
    return _attachmentInforLabel;
}
- (NSMutableArray *)attachmentImageArrayM
{
    if ( !_attachmentImageArrayM )
    {
        _attachmentImageArrayM = [NSMutableArray array];
    }
    return _attachmentImageArrayM;
}
@end