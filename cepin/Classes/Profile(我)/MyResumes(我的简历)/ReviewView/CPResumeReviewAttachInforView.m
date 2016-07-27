//
//  CPResumeReviewAttachInforView.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeReviewAttachInforView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPResumeReviewReformer.h"
#import "CPResumeAdditionalImageButton.h"
#import "CPCommon.h"
@interface CPResumeReviewAttachInforView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *attachmentInforLabel;
@property (nonatomic, strong) NSMutableArray *attachmentImageArrayM;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *separatorEndLine;
@end

@implementation CPResumeReviewAttachInforView

#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        self.separatorLine = separatorLine;
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.titleLabel.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.attachmentInforLabel];
        [self.attachmentInforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        UIView *separatorEndLine = [[UIView alloc] init];
        [separatorEndLine setBackgroundColor:[UIColor colorWithHexString:@"e6e6ea"]];
        [self addSubview:separatorEndLine];
        self.separatorEndLine = separatorEndLine;
        [separatorEndLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.mas_bottom );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 6 / CP_GLOBALSCALE ) );
        }];
    }
    return self;
}
- (void)configWithResume:(ResumeNameModel *)resumeModel
{
    [self resetData];
    _resumeModel = resumeModel;
    if ( !_resumeModel.AdditionInfo || 0 == [_resumeModel.AdditionInfo length] )
    {
        if(nil != resumeModel.ResumeAttachmentList && [resumeModel.ResumeAttachmentList count]>0){
            [self.attachmentInforLabel setHidden:YES];
            [self.titleLabel setHidden:NO];
            [self.separatorLine setHidden:NO];
            [self.separatorEndLine setHidden:NO];
        }else{
            [self.attachmentInforLabel setHidden:YES];
            [self.titleLabel setHidden:YES];
            [self.separatorLine setHidden:YES];
            [self.separatorEndLine setHidden:YES];
            return;
        }
    } else if(nil != resumeModel.ResumeAttachmentList && [resumeModel.ResumeAttachmentList count]>0){
       
        [self.attachmentInforLabel setHidden:NO];
        [self.titleLabel setHidden:NO];
        [self.separatorLine setHidden:NO];
        [self.separatorEndLine setHidden:NO];
    }
    else
    {
        [self.attachmentInforLabel setHidden:NO];
        [self.titleLabel setHidden:NO];
        [self.separatorLine setHidden:NO];
        [self.separatorEndLine setHidden:NO];
    }
    [self configAttachmentInforLabel:self.attachmentInforLabel content:_resumeModel.AdditionInfo];
    CGFloat marge = [CPResumeReviewReformer reviewAttachmentInfoImageMarge:_resumeModel];
    NSMutableArray *attachmentArrayM = resumeModel.ResumeAttachmentList;
    CGFloat imageWidth = ( kScreenWidth - 40 / CP_GLOBALSCALE * 6 ) / 5.0;
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
                make.left.equalTo( self.mas_left ).offset( x );
                make.width.equalTo( @( imageWidth ) );
                make.height.equalTo( @( imageHeight ) );
            }];
            tag++;
            x += 40 / CP_GLOBALSCALE + imageWidth;
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.separatorLine.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
                make.left.equalTo( self.mas_left ).offset( x );
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
    if ( [self.reviewAttachInformationViewDelegate respondsToSelector:@selector(reviewAttachInformationView:reviewImageButton:imageArray:isImage:originArray:)] )
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
        [self.reviewAttachInformationViewDelegate reviewAttachInformationView:self reviewImageButton:sender imageArray:tempArrayM isImage:sendIsImage originArray:attachmentArrayM];
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
    [self addSubview:button];
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
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setText:@"附加信息"];
    }
    return _titleLabel;
}
- (CPPositionDetailDescribeLabel *)attachmentInforLabel
{
    if ( !_attachmentInforLabel )
    {
        _attachmentInforLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_attachmentInforLabel setVerticalAlignment:VerticalAlignmentTop];
        [_attachmentInforLabel setNumberOfLines:0];
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