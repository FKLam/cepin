//
//  CreateResumeDialogView.m
//  cepin
//
//  Created by dujincai on 15/11/10.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "CreateResumeDialogView.h"
#import "MobClick.h"
#import "CPCommon.h"
@interface CreateResumeDialogView ()
@property (nonatomic, strong) UIButton *selectedButton;
@end
@implementation CreateResumeDialogView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
    }
    return self;
}
- (void)show
{
    self.hidden = NO;
    self.schoolCheckImg.hidden = YES;
    self.socialCheckImg.hidden = YES;
}
- (void)hide
{
    self.hidden = YES;
}
- (void)initView
{
    UIButton *maskButton = [[UIButton alloc]initWithFrame:self.bounds];
    maskButton.backgroundColor = [UIColor blackColor];
    maskButton.alpha = 0.70;
    [self addSubview:maskButton];
    @weakify(self)
    [maskButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        @strongify(self)
        self.hidden = YES;
        if ( [self.delegate respondsToSelector:@selector(clickedCancel)] )
        {
            [self.delegate clickedCancel];
        }
    }];
    //背景
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(40 / CP_GLOBALSCALE , self.viewCenterY - 100, self.viewWidth - 40 / CP_GLOBALSCALE * 2.0, 602 / CP_GLOBALSCALE)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [bgView.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [bgView.layer setMasksToBounds:YES];
    [self addSubview:bgView];
    self.titleLabel =  [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont systemFontOfSize:60.0 / CP_GLOBALSCALE];
    self.titleLabel.text = @"选择简历类型";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"404040"];
    [bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(bgView.mas_top).offset( 84 / CP_GLOBALSCALE );
        make.height.equalTo( @( self.titleLabel.font.pointSize ) );
        make.width.equalTo( @(bgView.viewWidth) );
    }];
    UIImageView *schoolImage = [[UIImageView alloc] init];
    schoolImage.image = [UIImage imageNamed:@"ic_student"];
    [bgView addSubview:schoolImage];
    [schoolImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( @( 40 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE ) );
        make.top.equalTo(self.titleLabel.mas_bottom).offset( (144 - 70) / CP_GLOBALSCALE / 2.0 + 84 / CP_GLOBALSCALE );
        make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
    }];
    self.schoolResumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.schoolResumeBtn.frame = CGRectZero;
    self.schoolResumeBtn.backgroundColor = [UIColor clearColor];
    [self.schoolResumeBtn setTitle:@"校园招聘简历" forState:UIControlStateNormal];
    self.schoolResumeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.schoolResumeBtn titleLabel].font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    [self.schoolResumeBtn setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
    [self.schoolResumeBtn setTag:2];
    [bgView addSubview:self.schoolResumeBtn];
    [self.schoolResumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( schoolImage.mas_right ).offset( 55 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        make.top.equalTo( self.titleLabel.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
        make.width.equalTo( bgView.mas_width );
    }];
    self.schoolCheckImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.schoolCheckImg setImage:[UIImage imageNamed:@"ic_tick"]];
    self.schoolCheckImg.hidden  = YES;
    [bgView addSubview:self.schoolCheckImg];
    [self.schoolCheckImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset( -( 40 + 55 ) / CP_GLOBALSCALE );
        make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
        make.centerY.equalTo(self.schoolResumeBtn.mas_centerY);
    }];
    [self.schoolResumeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.schoolCheckImg.hidden = NO;
        self.socialCheckImg.hidden = YES;
        self.selectedButton = self.schoolResumeBtn;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
            if ( self.selectedButton.tag == 2 )
                [self.delegate clickResume:2];//tag=1表示社招
        });
        [MobClick event:@"resumelist_item_click"];
    }];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithHexString:@"ede3e6"];
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        make.right.equalTo(bgView.mas_right).offset( -40 / CP_GLOBALSCALE );
        make.top.equalTo(self.schoolResumeBtn.mas_bottom);
    }];
    UIImageView *socialImage = [[UIImageView alloc] init];
    socialImage.image = [UIImage imageNamed:@"resume_experience"];
    [bgView addSubview:socialImage];
    [socialImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( bgView.mas_left ).offset( 40 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE );
        make.top.equalTo( lineView.mas_bottom ).offset( (144 - 70) / CP_GLOBALSCALE / 2.0 );
        make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
    }];
    self.socialResumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.socialResumeBtn.frame = CGRectZero;
    self.socialResumeBtn.backgroundColor = [UIColor clearColor];
    [self.socialResumeBtn setTitle:@"社会招聘简历" forState:UIControlStateNormal];
    self.socialResumeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.socialResumeBtn titleLabel].font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    [self.socialResumeBtn setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
    [self.socialResumeBtn setTag:1];
    [bgView addSubview:self.socialResumeBtn];
    [self.socialResumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( socialImage.mas_right ).offset( 50 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144.0 / CP_GLOBALSCALE ) );
        make.top.equalTo( lineView.mas_bottom );
        make.width.equalTo( bgView.mas_width );
    }];
    [self.socialResumeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.schoolCheckImg.hidden = YES;
        self.socialCheckImg.hidden = NO;
        self.selectedButton = self.socialResumeBtn;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
            if ( self.selectedButton.tag == 1 )
                [self.delegate clickResume:1];//tag=1表示社招
        });
        [MobClick event:@"resumelist_item_click"];
    }];
    self.socialCheckImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.socialCheckImg setImage:[UIImage imageNamed:@"ic_tick"]];
    self.socialCheckImg.hidden  = YES;
    [bgView addSubview:self.socialCheckImg];
    [self.socialCheckImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset( -( 40 + 55 ) / CP_GLOBALSCALE );
        make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
        make.centerY.equalTo(self.socialResumeBtn.mas_centerY);
    }];
}
@end