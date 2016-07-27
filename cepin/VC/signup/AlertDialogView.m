//
//  AlertDialogView.m
//  cepin
//
//  Created by dujincai on 15/12/9.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "AlertDialogView.h"
#import "MobClick.h"
#import "CPPositionDetailDescribeLabel.h"
@implementation AlertDialogView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isCepinView = NO;
    }
    return self;
}
//首次测评的弹出框
-(instancetype)initWithFrame:(CGRect)frame selector:(SEL)selector target:(id)target{
    self = [super initWithFrame:frame];
    if (self) {
        self.isCepinView = YES;
        self.sureSelector = selector;
        self.target = target;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title content:(NSString *)content selector:(SEL)selector target:(id)target{
    self = [super initWithFrame:frame];
    if (self) {
        self.isCepinView = NO;
        self.title = title;
        self.content = content;
        self.sureSelector = selector;
        self.target = target;
    }
    return self;
}
-(void)Show
{
    if (self.accountExitsBg)
    {
        self.hidden  = NO;
        self.accountExitsBg.hidden = NO;
        self.bgView.hidden = NO;
    }
    else
    {
        if ( self.isCepinView )
        {
            self.accountExitsBg = [[UIButton alloc] initWithFrame:self.bounds];
            self.accountExitsBg.backgroundColor = [UIColor blackColor];
            self.accountExitsBg.alpha = 0.75;
            [self addSubview: self.accountExitsBg];
            //背景
            CGFloat W = kScreenWidth - 40 / 3.0 * 2;
            CGFloat H = ( 84 + 50 + 84 + 48 * 3 + 24 * 3 + 84 + 2 + 144 ) / 3.0;
            CGFloat X = 40 / 3.0;
            CGFloat Y = ( kScreenHeight - H ) / 2.0;
            self.bgView = [[UIView alloc] initWithFrame:CGRectMake( X, Y, W, H)];
            self.bgView.backgroundColor = [UIColor whiteColor];
            [self.bgView.layer setCornerRadius:10 / 3.0];
            [self.bgView.layer setMasksToBounds:YES];
            [self addSubview:self.bgView];
            @weakify(self)
            [self.accountExitsBg handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                @strongify(self)
                self.hidden  = YES;
                self.bgView.hidden = YES;
                self.accountExitsBg.hidden = YES;
            }];
            UILabel *titleLabel =  [[UILabel alloc]initWithFrame:CGRectZero];
            titleLabel.font = [UIFont systemFontOfSize:50 / 3.0];
            titleLabel.text = @"是否对未来的职业生涯感到迷茫";
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
            [self.bgView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.equalTo(self.bgView.mas_top).offset( 84 / 3.0 );
                make.width.equalTo(self.bgView.mas_width);
                make.height.equalTo( @( 50 / 3.0 ) );
            }];
            NSString *str = @"来测一下极速职业测评吧!发掘你的潜在能力与优势发展行业,3D简历增加80%职业竞争力";
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:24 / 3.0];
            [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / 3.0]}];
            //获取要调整颜色的文字位置,调整颜色
            NSRange range1 = [[attStr string] rangeOfString:@"80%"];
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"]  range:range1];
            [attStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:60 / 3.0] range:range1];
            CPPositionDetailDescribeLabel *accountExistLabel =  [[CPPositionDetailDescribeLabel alloc] init];
            [accountExistLabel setVerticalAlignment:VerticalAlignmentTop];
            accountExistLabel.numberOfLines = 0;
            [accountExistLabel setAttributedText:attStr];
            [self.bgView addSubview:accountExistLabel];
            [accountExistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo( self.bgView.mas_left ).offset( 74 / 3.0 );
                make.right.equalTo( self.bgView.mas_right ).offset( -64 / 3.0);
                make.top.equalTo( titleLabel.mas_bottom ).offset( 84 / 3.0 );
            }];
            UIView *separatorLine = [[UIView alloc] init];
            [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
            [self.bgView addSubview:separatorLine];
            [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo( self.bgView.mas_bottom ).offset( -(144 / 3.0 + 2 / 3.0) );
                make.left.equalTo( self.bgView.mas_left );
                make.height.equalTo( @( 2 / 3.0 ) );
                make.right.equalTo( self.bgView.mas_right );
            }];
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelButton setTitle:@"稍后再说" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
            [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:48 / 3.0]];
            [self.bgView addSubview:cancelButton];
            [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                self.accountExitsBg.hidden = YES;
                self.bgView.hidden = YES;
                self.hidden  = YES;
            }];
            UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [sureButton setTitle:@"测评一下" forState:UIControlStateNormal];
            [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
            [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / 3.0]];
            [self.bgView addSubview:sureButton];
            [sureButton addTarget:self.target action:self.sureSelector forControlEvents:UIControlEventTouchUpInside];
            UIView *verSeparatorLine = [[UIView alloc] init];
            [verSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
            [self.bgView addSubview:verSeparatorLine];
            CGFloat buttonW = ( W - 2 / 3.0 ) / 2.0;
            [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo( self.bgView.mas_left );
                make.bottom.equalTo( self.bgView.mas_bottom );
                make.height.equalTo( @( 144 / 3.0 ) );
                make.width.equalTo( @( buttonW ) );
            }];
            [verSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( separatorLine.mas_bottom );
                make.left.equalTo( cancelButton.mas_right );
                make.bottom.equalTo( self.bgView.mas_bottom );
                make.width.equalTo( @( 2 / 3.0 ) );
            }];
            [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo( self.bgView.mas_right );
                make.bottom.equalTo( self.bgView.mas_bottom );
                make.height.equalTo( cancelButton );
                make.width.equalTo( cancelButton );
            }];
        }
        else
        {
            self.accountExitsBg = [[UIButton alloc]initWithFrame:self.bounds];
            self.accountExitsBg.backgroundColor = [UIColor blackColor];
            self.accountExitsBg.alpha = 0.75;
            [self addSubview: self.accountExitsBg];
            //背景
            self.bgView = [[UIView alloc]initWithFrame:CGRectMake(20, self.viewCenterY - 100, self.viewWidth - 40, 150)];
            self.bgView.backgroundColor = [UIColor whiteColor];
            //CGPointMake(self.viewCenterX, self.viewCenterY - 40);
            [self addSubview:self.bgView];
            @weakify(self)
            [self.accountExitsBg handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                @strongify(self)
                self.hidden  = YES;
                self.bgView.hidden = YES;
                self.accountExitsBg.hidden = YES;
            }];
            UILabel *titleLabel =  [[UILabel alloc]initWithFrame:CGRectZero];
            titleLabel.font = [[RTAPPUIHelper shareInstance] jobInformationDeliverButtonFont];
            titleLabel.text = self.title;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
            [self.bgView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.equalTo(self.bgView.mas_top).offset(10);
                make.height.equalTo(@(45));
                make.width.equalTo(@(self.bgView.viewWidth));
            }];
            UILabel *accountExistLabel =  [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.viewHeight+titleLabel.viewY+10, self.viewWidth-50, 40)];
                       accountExistLabel.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
            accountExistLabel.text = self.content;
            accountExistLabel.textAlignment = NSTextAlignmentLeft;
            accountExistLabel.numberOfLines = 0;
            accountExistLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
            [self.bgView addSubview:accountExistLabel];
            [accountExistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(10);
                make.right.equalTo(self.bgView.mas_right).offset(10);
                make.top.equalTo(titleLabel.mas_bottom);
                make.height.equalTo(@(40));
                make.centerX.equalTo(self.bgView.mas_centerX);
                make.width.equalTo(self.bgView.mas_width).offset(-20);
            }];
            UIView *endlineView = [[UIView alloc]initWithFrame:CGRectZero];
            endlineView.backgroundColor =[[RTAPPUIHelper shareInstance]lineColor];
            [self.bgView addSubview:endlineView];
            [endlineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left);
                make.height.equalTo(@(1));
                make.width.equalTo(self.bgView.mas_width);
                make.top.equalTo(accountExistLabel.mas_bottom).offset(10);
            }];
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame = CGRectZero;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[[RTAPPUIHelper shareInstance]subTitleColor] forState:UIControlStateNormal];
            [self.bgView addSubview:cancelBtn];
            [cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                self.accountExitsBg.hidden = YES;
                self.bgView.hidden = YES;
                self.hidden  = YES;
                NSRange range = [self.content rangeOfString:@"校招"];
                if ( range.length > 0 )
                {
                    [MobClick event:@"no_school_resume_cancel_click"];
                }
                else
                    [MobClick event:@"no_resume_cancel_click"];
            }];
            UIView *centerlineView = [[UIView alloc]initWithFrame:CGRectZero];
            centerlineView.backgroundColor =[[RTAPPUIHelper shareInstance]lineColor];
            [self.bgView addSubview:centerlineView];
            [centerlineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.bgView.mas_centerX);
                make.height.equalTo(@(40));
                make.width.equalTo(@(1));
                make.top.equalTo(endlineView.mas_bottom);
            }];
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectZero;
            [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[[RTAPPUIHelper shareInstance]labelColorGreen] forState:UIControlStateNormal];
            [loginBtn setTitleColor:[[RTAPPUIHelper shareInstance]labelColorGreen] forState:UIControlStateSelected];
            [loginBtn addTarget:self.target  action:self.sureSelector forControlEvents:UIControlEventTouchUpInside];
            [self.bgView addSubview:loginBtn];
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(20);
                make.width.equalTo(@(100));
                make.bottom.equalTo(centerlineView.mas_bottom);
                make.height.equalTo(centerlineView.mas_height);
            }];
            [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-20);
                make.width.equalTo(@(100));
                make.bottom.equalTo(centerlineView.mas_bottom);
                make.height.equalTo(centerlineView.mas_height);
            }];
        }
    }
}
- (void)showCancelButton
{
    if (self.accountExitsBg) {
        self.hidden  = NO;
        self.accountExitsBg.hidden = NO;
        self.bgView.hidden = NO;
    }
    else
    {
        self.accountExitsBg = [[UIButton alloc]initWithFrame:self.bounds];
        self.accountExitsBg.backgroundColor = [UIColor blackColor];
        self.accountExitsBg.alpha = 0.75;
        [self addSubview: self.accountExitsBg];
        //背景
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(20, self.viewCenterY - 100, self.viewWidth - 40, 150)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        //CGPointMake(self.viewCenterX, self.viewCenterY - 40);
        [self addSubview:self.bgView];
        @weakify(self)
        [self.accountExitsBg handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            self.hidden  = YES;
            self.bgView.hidden = YES;
            self.accountExitsBg.hidden = YES;
        }];
        UILabel *titleLabel =  [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.font = [[RTAPPUIHelper shareInstance] jobInformationDeliverButtonFont];
        titleLabel.text = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView.mas_centerX);
            make.top.equalTo(self.bgView.mas_top).offset(10);
            make.height.equalTo(@(45));
            make.width.equalTo( self.bgView.mas_width );
        }];
        UILabel *accountExistLabel =  [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.viewHeight+titleLabel.viewY+10, self.viewWidth-50, 40)];
        accountExistLabel.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
        accountExistLabel.text = self.content;
        accountExistLabel.textAlignment = NSTextAlignmentCenter;
        accountExistLabel.numberOfLines = 0;
        accountExistLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.bgView addSubview:accountExistLabel];
        [accountExistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.right.equalTo(self.bgView.mas_right).offset( -10);
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.equalTo(@(40));
            make.centerX.equalTo(self.bgView.mas_centerX);
        }];
        UIView *endlineView = [[UIView alloc]initWithFrame:CGRectZero];
        endlineView.backgroundColor =[[RTAPPUIHelper shareInstance]lineColor];
        [self.bgView addSubview:endlineView];
        [endlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left);
            make.height.equalTo(@(1));
            make.width.equalTo(self.bgView.mas_width);
            make.top.equalTo(accountExistLabel.mas_bottom).offset(10);
        }];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectZero;
        [cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[[RTAPPUIHelper shareInstance] jobInformationDeliverButtonFont]];
        [cancelBtn setTitleColor:[[RTAPPUIHelper shareInstance] labelColorGreen] forState:UIControlStateNormal];
        [self.bgView addSubview:cancelBtn];
        [cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.accountExitsBg.hidden = YES;
            self.bgView.hidden = YES;
            self.hidden  = YES;
        }];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(20);
            make.right.equalTo(self.bgView.mas_right).offset( -20);
            make.bottom.equalTo(self.bgView.mas_bottom);
            make.height.equalTo(@( 40.0 ));
        }];
    }
}
@end
