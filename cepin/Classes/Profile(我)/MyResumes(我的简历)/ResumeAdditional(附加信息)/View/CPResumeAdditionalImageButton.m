//
//  CPResumeAdditionalImageButton.m
//  cepin
//
//  Created by ceping on 16/2/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeAdditionalImageButton.h"
#import "CPCommon.h"
#define AdditionalImageWH ((kScreenWidth - 40 / CP_GLOBALSCALE * 5) / 4.0)
#define EditAdditionalImageWH ((kScreenWidth - 40 / CP_GLOBALSCALE * 8) / 5.0)
@interface CPResumeAdditionalImageButton ()
@property (nonatomic, strong) UIImageView *additionalImageView;
@property (nonatomic, strong) UIImageView *tipsImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) NSDictionary *attachmentModel;
@property (nonatomic, strong) UILabel *prograssLabel;
@property (nonatomic, strong) CALayer *prograssLayer;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *storageImageName;
@end
@implementation CPResumeAdditionalImageButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self addSubview:self.additionalImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.sizeLabel];
        [self.additionalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( AdditionalImageWH ) );
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.additionalImageView.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( self.additionalImageView.mas_left );
            make.right.equalTo( self.additionalImageView.mas_right );
        }];
        [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.nameLabel.mas_bottom ).offset( 0 / CP_GLOBALSCALE );
            make.left.equalTo( self.additionalImageView.mas_left );
            make.right.equalTo( self.additionalImageView.mas_right );
        }];
        [self addSubview:self.clickButton];
        [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
        }];
    }
    return self;
}
- (void)configWithAttachment:(NSDictionary *)attachmentModel
{
    _attachmentModel = attachmentModel;
    NSString *filePath = [_attachmentModel valueForKey:@"FilePath"];
    BOOL isImage = YES;
    if ( [filePath rangeOfString:@".docx"].location != NSNotFound || [filePath rangeOfString:@".doc"].location != NSNotFound )
    {
        isImage = NO;
        self.placeholderImage = [UIImage imageNamed:@"info_ic_doc"];
    }
    else if ( [filePath rangeOfString:@".pptx"].location != NSNotFound || [filePath rangeOfString:@".ppt"].location != NSNotFound )
    {
        isImage = NO;
        self.placeholderImage = [UIImage imageNamed:@"info_ic_ppt"];
    }
    else if ( [filePath rangeOfString:@".xlsx"].location != NSNotFound || [filePath rangeOfString:@".xls"].location != NSNotFound )
    {
        isImage = NO;
        self.placeholderImage = [UIImage imageNamed:@"info_ic_xls"];
    }
    else if ( [filePath rangeOfString:@".pdf"].location != NSNotFound )
    {
        isImage = NO;
        self.placeholderImage = [UIImage imageNamed:@"info_ic_pdf"];
    }
    if ( !self.placeholderImage && isImage )
    {
        self.placeholderImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_attachmentModel valueForKey:@"FilePath"]]]];
        if ( !self.placeholderImage )
            self.placeholderImage = [UIImage imageNamed:@"null_pic"];
    }
    if ( isImage )
        [self.additionalImageView sd_setImageWithURL:[NSURL URLWithString:[_attachmentModel valueForKey:@"FilePath"]] placeholderImage:self.placeholderImage];
    else
    {
        [self.additionalImageView setImage:self.placeholderImage];
    }
    NSString *fileName = [_attachmentModel valueForKey:@"Name"];
    NSString *regexString = @"Source_(\\w+).";
    NSRange range = [fileName rangeOfString:regexString options:NSRegularExpressionSearch];
    NSString *temp = nil;
    if ( range.location != NSNotFound )
    {
        temp = [fileName substringWithRange:NSMakeRange(7, range.length - 8)];
    }
    [self.nameLabel setText:temp];
    NSNumber *sizeNumber = [_attachmentModel valueForKey:@"AttachmentSize"];
    CGFloat fileSize = [sizeNumber floatValue];
    fileSize /= ( 1024.0 * 1024.0 );
    [self.sizeLabel setText:[NSString stringWithFormat:@"%.2fM", fileSize]];
    [self.tipsImageView setHidden:NO];
    [self.prograssLabel setHidden:YES];
    [self.prograssLayer setHidden:YES];
    [self.clickButton setHidden:NO];
}
- (void)configWithAttachment:(NSDictionary *)attachmentModel hideTips:(BOOL)hideTips
{
    _attachmentModel = attachmentModel;
    NSString *filePath = [_attachmentModel valueForKey:@"FilePath"];
    BOOL isImage = YES;
    if ( [filePath rangeOfString:@".docx"].location != NSNotFound || [filePath rangeOfString:@".doc"].location != NSNotFound )
    {
        isImage = NO;
        self.placeholderImage = [UIImage imageNamed:@"info_ic_doc"];
    }
    else if ( [filePath rangeOfString:@".pptx"].location != NSNotFound || [filePath rangeOfString:@".ppt"].location != NSNotFound )
    {
        isImage = NO;
        self.placeholderImage = [UIImage imageNamed:@"info_ic_ppt"];
    }
    else if ( [filePath rangeOfString:@".xlsx"].location != NSNotFound || [filePath rangeOfString:@".xls"].location != NSNotFound )
    {
        isImage = NO;
        self.placeholderImage = [UIImage imageNamed:@"info_ic_xls"];
    }
    else if ( [filePath rangeOfString:@".pdf"].location != NSNotFound )
    {
        isImage = NO;
        self.placeholderImage = [UIImage imageNamed:@"info_ic_pdf"];
    }
    if ( !self.placeholderImage && isImage )
    {
        self.placeholderImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_attachmentModel valueForKey:@"FilePath"]]]];
        if ( !self.placeholderImage )
            self.placeholderImage = [UIImage imageNamed:@"null_pic"];
    }
    if ( isImage )
        [self.additionalImageView sd_setImageWithURL:[NSURL URLWithString:[_attachmentModel valueForKey:@"FilePath"]] placeholderImage:self.placeholderImage];
    else
    {
        [self.additionalImageView setImage:self.placeholderImage];
    }
    NSString *fileName = [_attachmentModel valueForKey:@"Name"];
    NSString *regexString = @"Source_(\\w+).";
    NSRange range = [fileName rangeOfString:regexString options:NSRegularExpressionSearch];
    NSString *temp = nil;
    if ( range.location != NSNotFound )
    {
        temp = [fileName substringWithRange:NSMakeRange(7, range.length - 8)];
    }
    [self.nameLabel setText:temp];
    NSNumber *sizeNumber = [_attachmentModel valueForKey:@"AttachmentSize"];
    CGFloat fileSize = [sizeNumber floatValue];
    fileSize /= ( 1024.0 * 1024.0 );
    [self.sizeLabel setText:[NSString stringWithFormat:@"%.2fM", fileSize]];
    [self.tipsImageView setHidden:hideTips];
    [self.prograssLabel setHidden:YES];
    [self.prograssLayer setHidden:YES];
    [self.clickButton setHidden:NO];
}
- (void)configWithImage:(UIImage *)image imageName:(NSString *)imageName
{
    self.storageImageName = imageName;
    self.placeholderImage = image;
    [self.additionalImageView setImage:self.placeholderImage];
    [self.prograssLabel setHidden:NO];
    [self.prograssLayer setHidden:NO];
    [self.clickButton setHidden:YES];
    [self.prograssLabel setText:@"0%"];
}
- (void)configError
{
    [self.retryButton setHidden:NO];
    [self.prograssLabel setHidden:YES];
    [self.prograssLayer setHidden:NO];
    [self.clickButton setHidden:YES];
    [self.prograssLayer setFrame:CGRectMake(0, 0, AdditionalImageWH, AdditionalImageWH)];
}
- (void)setPrograssWithTotalBytesWritten:(CGFloat)totalBytesWritten totalBytesExpectedToWrite:(CGFloat)totalBytesExpectedToWrite
{
    CGFloat progress = totalBytesWritten / totalBytesExpectedToWrite;
    NSInteger progressInt = progress * 100;
    [self.prograssLabel setText:[NSString stringWithFormat:@"%ld%%", progressInt]];
    [self.prograssLayer setFrame:CGRectMake(0, 0, AdditionalImageWH, AdditionalImageWH * (1 - progress) )];
}
- (void)configWithAttachment:(NSDictionary *)attachmentModel isChangeFrame:(BOOL)isChangeFrame
{
    if ( isChangeFrame )
    {
        [self.nameLabel setFont:[UIFont systemFontOfSize:30 / CP_GLOBALSCALE]];
        [self.sizeLabel setFont:[UIFont systemFontOfSize:30 / CP_GLOBALSCALE]];
        [self.additionalImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( EditAdditionalImageWH ) );
        }];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.additionalImageView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.left.equalTo( self.additionalImageView.mas_left );
            make.right.equalTo( self.additionalImageView.mas_right );
        }];
        [self.sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.nameLabel.mas_bottom ).offset( 0 / CP_GLOBALSCALE );
            make.left.equalTo( self.additionalImageView.mas_left );
            make.right.equalTo( self.additionalImageView.mas_right );
        }];
        [self.tipsImageView setHidden:isChangeFrame];
    }
    [self configWithAttachment:attachmentModel hideTips:YES];
}
- (UIImage *)getPlaceholderImage
{
    return self.placeholderImage;
}
- (NSString *)getStorageImageName
{
    return self.storageImageName;
}
#pragma mark - getter mothed
- (UIImageView *)additionalImageView
{
    if ( !_additionalImageView )
    {
        _additionalImageView = [[UIImageView alloc] init];
        [_additionalImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_additionalImageView setUserInteractionEnabled:YES];
        [_additionalImageView.layer setMasksToBounds:YES];
        CALayer *prograssLayer = [[CALayer alloc] init];
        [prograssLayer setFrame:CGRectMake(0, 0, AdditionalImageWH, AdditionalImageWH)];
        [prograssLayer setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.5].CGColor];
        [_additionalImageView.layer addSublayer:prograssLayer];
        [prograssLayer setHidden:YES];
        self.prograssLayer = prograssLayer;
        [_additionalImageView addSubview:self.tipsImageView];
        [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _additionalImageView.mas_bottom ).offset( -12 / CP_GLOBALSCALE );
            make.right.equalTo( _additionalImageView.mas_right ).offset( -12 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [_additionalImageView addSubview:self.prograssLabel];
        [self.prograssLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _additionalImageView.mas_top );
            make.left.equalTo( _additionalImageView.mas_left );
            make.bottom.equalTo( _additionalImageView.mas_bottom );
            make.right.equalTo( _additionalImageView.mas_right );
        }];
        [_additionalImageView addSubview:self.retryButton];
        [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _additionalImageView.mas_top );
            make.left.equalTo( _additionalImageView.mas_left );
            make.bottom.equalTo( _additionalImageView.mas_bottom );
            make.right.equalTo( _additionalImageView.mas_right );
        }];
    }
    return _additionalImageView;
}
- (UIImageView *)tipsImageView
{
    if ( !_tipsImageView )
    {
        _tipsImageView = [[UIImageView alloc] init];
        [_tipsImageView setImage:[UIImage imageNamed:@"info_ic_done"]];
        [_tipsImageView setHidden:YES];
    }
    return _tipsImageView;
}
- (UILabel *)nameLabel
{
    if ( !_nameLabel )
    {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont systemFontOfSize:30 / CP_GLOBALSCALE]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    }
    return _nameLabel;
}
- (UILabel *)sizeLabel
{
    if ( !_sizeLabel )
    {
        _sizeLabel = [[UILabel alloc] init];
        [_sizeLabel setFont:[UIFont systemFontOfSize:30 / CP_GLOBALSCALE]];
        [_sizeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_sizeLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _sizeLabel;
}
- (UIButton *)clickButton
{
    if ( !_clickButton )
    {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickButton setBackgroundColor:[UIColor clearColor]];
        [_clickButton setHidden:YES];
    }
    return _clickButton;
}
- (UILabel *)prograssLabel
{
    if ( !_prograssLabel )
    {
        _prograssLabel = [[UILabel alloc] init];
        [_prograssLabel setBackgroundColor:[UIColor clearColor]];
        [_prograssLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_prograssLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_prograssLabel setTextAlignment:NSTextAlignmentCenter];
        [_prograssLabel setHidden:YES];
    }
    return _prograssLabel;
}
- (CPWResumeAdditionImageRetryButton *)retryButton
{
    if ( !_retryButton )
    {
        _retryButton = [CPWResumeAdditionImageRetryButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setTitle:@"重试" forState:UIControlStateNormal];
        [_retryButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_retryButton.titleLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_retryButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_retryButton setImage:[UIImage imageNamed:@"info_ic_retry"] forState:UIControlStateNormal];
        [_retryButton setHidden:YES];
        [_retryButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [self.resumeAdditionalImageButtonDelegate respondsToSelector:@selector(resumeAdditionalImageButton:retryButton:)] )
            {
                [self.retryButton setHidden:YES];
                [self.prograssLabel setHidden:NO];
                [self.prograssLayer setHidden:NO];
                [self.clickButton setHidden:YES];
                [self.prograssLabel setText:@"0%"];
                [self.retryButton setTag:self.tag];
                [self.resumeAdditionalImageButtonDelegate resumeAdditionalImageButton:self retryButton:self.retryButton];
            }
        }];
    }
    return _retryButton;
}
@end